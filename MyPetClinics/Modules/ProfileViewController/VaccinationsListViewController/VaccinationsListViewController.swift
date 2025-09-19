//
//  VaccinationsListViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 14.9.2025.
//

import UIKit

final class VaccinationsListViewController: UIViewController {
    
    private var allItems: [VaccinationListItem] = []
    private var selectedFilterTitles: Set<String> = []

    // MARK: - Public (header context)
    private let petDisplayName: String
    private let petAvatarImageData: Data?
    private let petAvatarFileName: String?
    private let petId: UUID?

    // MARK: - UI
    private let bottomBarContainerView = UIView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // Header subviews (для tableHeaderView)
    private let headerContainerView = UIView()
    private let headerHorizontalStackView = UIStackView()
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let petNameLabel = Labels(style: .bold34TitleLabelStyle)
    private let sectionTitleLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle,
                       text: String(localized: "vaccinations_title", defaultValue: "Vaccinations"))
        label.textAlignment = .center
        return label
    }()
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var sortButton = Buttons(
        style: .actionButtonStyle(title: String(localized: "sort_title"), systemIconName: "arrow.up.arrow.down"),
        target: self, action: #selector(sortTapped)
    )
    private lazy var filterButton = Buttons(
        style: .actionButtonStyle(title: String(localized: "filter_title"), systemIconName: "slider.horizontal.3"),
        target: self, action: #selector(filterTapped)
    )

    // Bottom bar
    private lazy var addVaccinationButton = Buttons(
        style: .primary20new(title: String(localized: "add_vaccination_title", defaultValue: "Add vaccination")),
        target: self, action: #selector(addVaccinationTapped)
    )

    // MARK: - State
    private var items: [VaccinationListItem] = []
    private let listDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()

    private let sortOptions = [
        "Date (newest first)",
        "Date (oldest first)"
    ]
    private var selectedSortOptionIndex: Int?

    // MARK: - Init
    init(petDisplayName: String, petAvatarImageData: Data?, petAvatarFileName: String?, petId: UUID?) {
        self.petDisplayName = petDisplayName
        self.petAvatarImageData = petAvatarImageData
        self.petAvatarFileName = petAvatarFileName
        self.petId = petId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupTable()
        setupBottomBar()
        buildAndApplyTableHeader()
        fillHeader()
        reloadFromStorage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFromStorage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // пересчитать высоту header при изменении ширины
        guard let header = tableView.tableHeaderView else { return }
        let targetSize = CGSize(width: tableView.bounds.width, height: 0)
        let height = header.systemLayoutSizeFitting(targetSize,
                                                    withHorizontalFittingPriority: .required,
                                                    verticalFittingPriority: .fittingSizeLevel).height
        if abs(header.frame.height - height) > 0.5 {
            header.frame.size.height = height
            tableView.tableHeaderView = header
        }
    }

    private func reloadFromStorage() {
        if let petId {
            allItems = VaccinationsStorage.shared.fetchVaccinations(forPetId: petId)
        } else {
            allItems = []
        }
        applyFiltersAndSortAndReload()
    }
    
    private func applyFiltersAndSortAndReload() {
        // Фоллбек как в ячейке: "Vaccination", если title nil/пуст
        let fallback = String(localized: "vaccination_default_title", defaultValue: "Vaccination")
        
        if selectedFilterTitles.isEmpty {
            items = allItems
        } else {
            items = allItems.filter { item in
                let title = (item.title?.nilIfBlank) ?? fallback
                return selectedFilterTitles.contains(title)
            }
        }
        
        applySelectedSort()
        
        actionsStackView.isHidden = items.isEmpty
        tableView.reloadData()
        
        if items.isEmpty {
            // фон таблицы на весь экран
            let emptyView = UIView(frame: tableView.bounds)
            emptyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let label = Labels(
                style: .emptyStateTitleLabelStyle,
                text: String(localized: "no_vaccinations_title", defaultValue: "No Vaccinations")
            )
            label.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor) // <-- по центру Y
            ])
            
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }

    
    // MARK: - Setup
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain, target: self, action: #selector(closeTapped))
        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeButton
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(VaccinationTableViewCell.self, forCellReuseIdentifier: VaccinationTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64) // место под кнопку
        ])
    }

    private func setupBottomBar() {
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarContainerView)

        let readable = bottomBarContainerView.readableContentGuide
        bottomBarContainerView.addSubview(addVaccinationButton)

        NSLayoutConstraint.activate([
            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            addVaccinationButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            addVaccinationButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            addVaccinationButton.topAnchor.constraint(equalTo: bottomBarContainerView.topAnchor, constant: 8),
            addVaccinationButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
            addVaccinationButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
            addVaccinationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }

    private func buildAndApplyTableHeader() {
        // header stack
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 16
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        // top row with avatar and name
        headerHorizontalStackView.axis = .horizontal
        headerHorizontalStackView.alignment = .center
        headerHorizontalStackView.spacing = 16
        headerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        let avatarSide: CGFloat = 80
        avatarImageView.layer.cornerRadius = avatarSide / 2

        headerHorizontalStackView.addArrangedSubview(avatarImageView)
        headerHorizontalStackView.addArrangedSubview(petNameLabel)
        petNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        actionsStackView.addArrangedSubview(sortButton)
        actionsStackView.addArrangedSubview(filterButton)

        headerStack.addArrangedSubview(headerHorizontalStackView)
        headerStack.addArrangedSubview(sectionTitleLabel)
        headerStack.addArrangedSubview(actionsStackView)

        let container = UIView()
        container.addSubview(headerStack)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),

            headerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            headerStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            
            actionsStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 40),
            actionsStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40)
        ])

        // авто-расчёт высоты
        let targetSize = CGSize(width: view.bounds.width, height: 0)
        let height = container.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel).height
        container.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        tableView.tableHeaderView = container
    }

    private func fillHeader() {
        petNameLabel.text = petDisplayName.nilIfBlank
            ?? String(localized: "name_title", defaultValue: "Name")
        if let data = petAvatarImageData, let image = UIImage(data: data) {
            avatarImageView.image = image
        } else if let file = petAvatarFileName {
            avatarImageView.image = UIImage.loadOrPlaceholder(named: file, in: traitCollection)
        } else {
            avatarImageView.image = UIImage(named: "no photo")
        }
    }

    private func applySelectedSort() {
        guard let index = selectedSortOptionIndex else { return }
        switch index {
        case 0: // самые новые сверху
            items.sort { ($0.dateGiven ?? $0.createdAt) > ($1.dateGiven ?? $1.createdAt) }
        case 1: // самые старые сверху
            items.sort { ($0.dateGiven ?? $0.createdAt) < ($1.dateGiven ?? $1.createdAt) }
        default:
            break
        }
    }

    // MARK: - Actions
    @objc private func filterTapped() {
        // Список уникальных названий из allItems
        let fallback = String(localized: "vaccination_default_title", defaultValue: "Vaccination")
        let titles = Set(allItems.map { ($0.title?.nilIfBlank) ?? fallback })
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

        // Один раздел «By title»
        let section = FilterSection(
            title: String(localized: "filter_by_title", defaultValue: "By title"),
            options: titles.map { FilterOption(name: $0) }
        )

        let filtersVC = FiltersViewController(sections: [section])
        filtersVC.setSelectedOptions(self.selectedFilterTitles)
        filtersVC.onFilterOptionsSave = { [weak self] options in
            guard let self = self else { return }
            self.selectedFilterTitles = options
            self.applyFiltersAndSortAndReload()
        }

        if #available(iOS 15.0, *), let sheet = filtersVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.detents = [.large()]
        } else {
            filtersVC.modalPresentationStyle = .fullScreen
        }
        present(filtersVC, animated: true)
    }

    
    @objc private func closeTapped() {
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func addVaccinationTapped() {
        let viewController = CreateNewVaccinationViewController(
            petDisplayName: petDisplayName,
            petAvatarImageData: petAvatarImageData,
            petAvatarFileName: petAvatarFileName,
            petId: petId
        )
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func sortTapped() {
        let sortVC = SortViewController()
        sortVC.options = sortOptions
        sortVC.selectedIndex = selectedSortOptionIndex
        sortVC.delegate = self
        if #available(iOS 15.0, *), let sheet = sortVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            let rowHeight: CGFloat = 44
            let rowsHeight = rowHeight * CGFloat(sortOptions.count)
            let topPadding: CGFloat = 12, titleHeight: CGFloat = 21, betweenTitleAndTable: CGFloat = 4
            let headerHeight = topPadding + titleHeight + betweenTitleAndTable
            let buttonHeight: CGFloat = 44, betweenTableAndButton: CGFloat = 4
            let bottomSafeArea = view.safeAreaInsets.bottom
            let footerHeight = buttonHeight + betweenTableAndButton + bottomSafeArea
            let total = headerHeight + rowsHeight + footerHeight
            sheet.detents = [.custom(identifier: .init("vaccinations.sort")) { _ in total }]
        }
        present(sortVC, animated: true)
    }
}

// MARK: - UITableViewDataSource / Delegate
extension VaccinationsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: VaccinationTableViewCell.reuseIdentifier, for: indexPath) as? VaccinationTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: items[indexPath.row], dateFormatter: listDateFormatter)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        let detailsViewController = VaccinationDetailsViewController(
            petDisplayName: petDisplayName,
            petAvatarImageData: petAvatarImageData,
            petAvatarFileName: petAvatarFileName,
            vaccinationId: item.id
        )
        navigationController?.pushViewController(detailsViewController, animated: true)
    }


    // Свайп Delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: String(localized: "delete_title", defaultValue: "Delete")) { [weak self] _, _, completion in
            guard let self else { completion(false); return }
            let item = self.items[indexPath.row]
            if VaccinationsStorage.shared.deleteVaccination(by: item.id) {
                self.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.reloadFromStorage() // чтобы пересчитать empty state/видимость кнопок
                completion(true)
            } else {
                completion(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension VaccinationsListViewController: SortOptionsViewControllerDelegate {
    func sortOptionsViewController(
        _ controller: SortViewController,
        didSelectOptionAt index: Int
    ) {
        selectedSortOptionIndex = index
        applySelectedSort()
        tableView.reloadData()
    }
}
