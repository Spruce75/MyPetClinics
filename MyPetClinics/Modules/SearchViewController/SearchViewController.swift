//
//  SearchViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 4.6.2025.
//

import UIKit

final class SearchViewController: UIViewController, SortOptionsViewControllerDelegate {
    
    // MARK: - Subviews
    private let backgroundImageView = Images(style: .imageForBackground(name: "bird"))
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = String(localized: "search_placeholder")
        searchBar.tintColor = .systemBlue
        searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let actionsStackView = StackViews(style: .horizontal6StackView)
    
    private lazy var sortButton = Buttons(
        style: .actionButtonStyle(
            title: String(localized: "sort_title"),
            systemIconName: "arrow.up.arrow.down"
        ),
        target: self,
        action: #selector(sortTapped)
    )
    private lazy var filterButton = Buttons(
        style: .actionButtonStyle(
            title: String(localized: "filter_title"),
            systemIconName: "slider.horizontal.3"
        ),
        target: self,
        action: #selector(filterTapped)
    )
    private lazy var mapButton = Buttons(
        style: .actionButtonStyle(
            title: String(localized: "map_title"),
            systemIconName: "map"
        ),
        target: self,
        action: #selector(mapTapped)
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier
        )
        tableView.isHidden = true
        return tableView
    }()
    
    private let emptyStateView = EmptyStateView()
    private let loadingView = LoadingView()
    
    // MARK: - Switchable constraints (safe optionals)
    private var emptyTopToActionsConstraint: NSLayoutConstraint?
    private var emptyTopToSearchConstraint: NSLayoutConstraint?
    
    // MARK: - Data
    private let clinicService: VetClinicService
    private var vetClinics: [VetClinic] = []
    
    // MARK: - Search & Filtering
    private var filteredClinics: [VetClinic] = [] {
        didSet { tableView.reloadData() }
    }
    private var hasSearched = false
    private var searchBarIsEmpty: Bool { (searchBar.text ?? "").isEmpty }
    private var isFiltering: Bool { hasSearched && (!searchBarIsEmpty || !selectedFilterOptions.isEmpty) }
    
    // MARK: - Filters
    private var selectedFilterOptions: Set<String> = []
    
    // MARK: - Gestures
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    // MARK: - Sort Options
    private let sortOptions: [String] = [
        "Rating (0 to 5)",
        "Rating (5 to 0)"
    ]
    private var selectedSortOptionIndex: Int?
    
    // MARK: - Init
    init(clinicService: VetClinicService = MockVetClinicService()) {
        self.clinicService = clinicService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
        setupSearchBarStyle()
        setupInitialState()
        fetchClinics()
        
        emptyStateView.isHidden = true
        emptyStateView.onChangeFiltersTapped = { [weak self] in
            self?.filterTapped()
        }
        emptyStateView.onClearFiltersTapped = { [weak self] in
            guard let self = self else { return }
            self.selectedFilterOptions.removeAll()
            self.filterContentForSearchText(self.searchBar.text ?? "")
        }
    }
    
    // MARK: - SortOptionsViewControllerDelegate
    func sortOptionsViewController(
        _ controller: SortOptionsViewController,
        didSelectOptionAt index: Int
    ) {
        selectedSortOptionIndex = index
        let sortedClinics: [VetClinic]
        switch index {
        case 0: sortedClinics = filteredClinics.sorted { $0.rating < $1.rating }
        case 1: sortedClinics = filteredClinics.sorted { $0.rating > $1.rating }
        default: sortedClinics = filteredClinics
        }
        filteredClinics = sortedClinics
    }
    
    // MARK: - Private Methods
    private func setupSearchBarStyle() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.systemFont(ofSize: 17)
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.textColor = .label
            textField.backgroundColor = .secondarySystemBackground
            textField.clearButtonMode = .whileEditing
        }
        definesPresentationContext = true
    }
    
    private func fetchClinics() {
        clinicService.fetchClinics { [weak self] clinics in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.vetClinics = clinics
            }
        }
    }
    
    private func setupInitialState() {
        updateUIState()
    }
    
    private func setActionsForegroundColor(isInverted: Bool) {
        let color: UIColor = isInverted ? .white : .label
        [sortButton, filterButton, mapButton].forEach {
            $0.tintColor = color
            $0.setTitleColor(color, for: .normal)
        }
    }
    
    /// 4 состояния:
    /// 1) старт (не искали) → bird, только searchBar
    /// 2) есть результаты → butterfly, actionsStackView + table
    /// 3) пусто из-за текста (фильтров нет) → dogNothingFound, только заголовок, без панели действий
    /// 4) пусто из-за фильтров (есть выбранные фильтры) → dogNothingFound, панель действий видна поверх фона + EmptyState с кнопками
    private func updateUIState() {
        let hasFilters = !selectedFilterOptions.isEmpty
        let hasResults = hasSearched && !filteredClinics.isEmpty
        let noResults  = hasSearched && filteredClinics.isEmpty
        
        if !hasSearched {
            // 1) старт
            backgroundImageView.image = UIImage(named: "bird")
            actionsStackView.isHidden = true
            tableView.isHidden = true
            emptyStateView.isHidden = true
            setActionsForegroundColor(isInverted: false)
            return
        }
        
        if hasResults {
            // 2) найдено
            backgroundImageView.image = UIImage(named: "butterfly")
            actionsStackView.isHidden = false
            tableView.isHidden = false
            emptyStateView.isHidden = true
            setActionsForegroundColor(isInverted: false)
            return
        }
        
        if noResults {
            backgroundImageView.image = UIImage(named: "dogNothingFound")
            tableView.isHidden = true
            
            if hasFilters {
                // 4) пусто из-за фильтров: actions поверх фона, белые надписи
                actionsStackView.isHidden = false
                emptyStateView.isHidden = false
                emptyStateView.configure(mode: .withActions)
                setActionsForegroundColor(isInverted: true)
                
                // пустое состояние — ниже панели действий
                emptyTopToSearchConstraint?.isActive = false
                emptyTopToActionsConstraint?.isActive = true
            } else {
                // 3) пусто из-за текста: без панели действий, только заголовок
                actionsStackView.isHidden = true
                emptyStateView.isHidden = false
                emptyStateView.configure(mode: .textOnly)
                setActionsForegroundColor(isInverted: false)
                
                emptyTopToActionsConstraint?.isActive = false
                emptyTopToSearchConstraint?.isActive = true
            }
        }
        
        view.layoutIfNeeded()
    }
    
//    private func filterContentForSearchText(_ searchText: String) {
//        hasSearched = true
//        loadingView.show()
//        emptyStateView.isHidden = true
//        tableView.isHidden = true
//        actionsStackView.isHidden = true
//        
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let self = self else { return }
//            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//            
//            let predicates: [(VetClinic) -> Bool] = FilterConfigurationProvider.defaultSections()
//                .flatMap { $0.options }
//                .filter { self.selectedFilterOptions.contains($0.name) }
//                .compactMap { option in
//                    switch option.name {
//                    case "Vet clinic", "Vet hospital", "Private veterinarian":
//                        return { clinic in clinic.type == option.name }
//                    case "Open 24/7":
//                        return { clinic in clinic.emergencyInfo?.localizedCaseInsensitiveContains("24/7") == true }
//                    case "Weekend & Holiday Open":
//                        return { clinic in clinic.emergencyInfo?.localizedCaseInsensitiveContains("weekend") == true }
//                    case "Emergency Services":
//                        return { clinic in clinic.emergencyInfo != nil }
//                    case "Online Consultation Available":
//                        return { clinic in clinic.onlineConsultationAvailable }
//                    default:
//                        return nil
//                    }
//                }
//            
//            let results = self.vetClinics.filter { clinic in
//                let matchesText = query.isEmpty
//                    || clinic.name.lowercased().contains(query)
//                    || clinic.address.lowercased().contains(query)
//                let matchesFilters = predicates.allSatisfy { $0(clinic) }
//                return matchesText && matchesFilters
//            }
//            
//            DispatchQueue.main.async {
//                self.filteredClinics = results
//                self.updateUIState()
//                self.loadingView.hide()
//            }
//        }
//    }
    
    private func filterContentForSearchText(_ searchText: String) {
        hasSearched = true
        loadingView.show()
        emptyStateView.isHidden = true
        tableView.isHidden = true
        actionsStackView.isHidden = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            // OR-группа: типы клиник
            let typeOptions: Set<String> = ["Vet clinic", "Vet hospital", "Private veterinarian"]
            let selectedTypes = self.selectedFilterOptions.intersection(typeOptions)

            // AND-флаги: остальные фильтры
            let need247       = self.selectedFilterOptions.contains("Open 24/7")
            let needWeekend   = self.selectedFilterOptions.contains("Weekend & Holiday Open")
            let needEmergency = self.selectedFilterOptions.contains("Emergency Services")
            let needOnline    = self.selectedFilterOptions.contains("Online Consultation Available")

            let results = self.vetClinics.filter { clinic in
                // текст
                let matchesText = query.isEmpty
                    || clinic.name.lowercased().contains(query)
                    || clinic.address.lowercased().contains(query)

                // тип (ИЛИ)
                let matchesType = selectedTypes.isEmpty || selectedTypes.contains(clinic.type)

                // прочие (И)
                let emergencyText = clinic.emergencyInfo?.lowercased() ?? ""
                let matches247       = !need247       || emergencyText.contains("24/7")
                let matchesWeekend   = !needWeekend   || emergencyText.contains("weekend")
                let matchesEmergency = !needEmergency || clinic.emergencyInfo != nil
                let matchesOnline    = !needOnline    || clinic.onlineConsultationAvailable

                return matchesText
                    && matchesType
                    && matches247
                    && matchesWeekend
                    && matchesEmergency
                    && matchesOnline
            }

            DispatchQueue.main.async {
                self.filteredClinics = results
                self.updateUIState()
                self.loadingView.hide()
            }
        }
    }

    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func sortTapped() {
        let sortVC = SortOptionsViewController()
        sortVC.options = sortOptions
        sortVC.selectedIndex = selectedSortOptionIndex
        sortVC.delegate = self
        if #available(iOS 15.0, *) {
            if let sheet = sortVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                let rowHeight: CGFloat = 44
                let rowsHeight = rowHeight * CGFloat(sortOptions.count)
                let topPadding: CGFloat = 12
                let titleHeight: CGFloat = 21
                let betweenTitleAndTable: CGFloat = 4
                let headerHeight = topPadding + titleHeight + betweenTitleAndTable
                let buttonHeight: CGFloat = 44
                let betweenTableAndButton: CGFloat = 4
                let bottomSafeArea = view.safeAreaInsets.bottom
                let footerHeight = buttonHeight + betweenTableAndButton + bottomSafeArea
                let totalHeight = headerHeight + rowsHeight + footerHeight
                let detent = UISheetPresentationController.Detent.custom(identifier: .init("sort")) { _ in totalHeight }
                sheet.detents = [detent]
            }
        } else {
            sortVC.modalPresentationStyle = .fullScreen
        }
        present(sortVC, animated: true)
    }
    
    @objc private func filterTapped() {
        let filtersVC = FiltersViewController()
        
        filtersVC.setSelectedOptions(self.selectedFilterOptions)
        
        filtersVC.onFilterOptionsSave = { [weak self] options in
            guard let self = self else { return }
            self.selectedFilterOptions = options
            self.filterContentForSearchText(self.searchBar.text ?? "")
        }
        if #available(iOS 15.0, *) {
            if let sheet = filtersVC.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.detents = [.large()]
            }
        } else {
            filtersVC.modalPresentationStyle = .fullScreen
        }
        present(filtersVC, animated: true)
    }
    
    @objc private func mapTapped() { /* TODO */ }
}

// MARK: - Layout
extension SearchViewController {
    private func setupViewsAndConstraints() {
        view.addGestureRecognizer(tapGesture)
        
        // Порядок добавления важен: фон добавляем первым
        [backgroundImageView, searchBar, actionsStackView, tableView, emptyStateView, loadingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [sortButton, filterButton, mapButton].forEach {
            actionsStackView.addArrangedSubview($0)
        }
        
        // Переключаемые top-констрейнты для EmptyStateView
        emptyTopToActionsConstraint = emptyStateView.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: 24)
        emptyTopToSearchConstraint  = emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40)
        emptyTopToSearchConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // Background — всегда на весь экран (панель действий рисуется поверх)
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // SearchBar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Actions
            actionsStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionsStackView.heightAnchor.constraint(equalToConstant: 32),
            
            // Table
            tableView.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty state (top — переключаемый выше)
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
            
            // Loading overlay
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            selectedFilterOptions.removeAll()
            hasSearched = false
            filteredClinics = []
            updateUIState()
        } else {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        selectedFilterOptions.removeAll()
        hasSearched = false
        filteredClinics = []
        updateUIState()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredClinics.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let clinic = filteredClinics[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: clinic) { [weak self] updated in
            guard let self = self else { return }
            self.clinicService.updateBookmark(updated, isBookmarked: updated.isBookmarked) {
                self.filteredClinics[indexPath.row] = updated
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let clinic = filteredClinics[indexPath.row]
        let detailsVC = ClinicDetailsViewController(
            clinic: clinic,
            clinicService: clinicService
        ) { [weak self] updatedClinic in
            guard let self = self else { return }
            self.filteredClinics[indexPath.row] = updatedClinic
            self.clinicService.updateBookmark(updatedClinic, isBookmarked: updatedClinic.isBookmarked) {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
