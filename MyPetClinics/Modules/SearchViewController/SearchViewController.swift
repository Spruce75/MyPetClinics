//
//  SearchViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 4.6.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Data
    private let clinicService: VetClinicService
    private var vetClinics: [VetClinic] = []
    
    // MARK: - Search & Filtering
    private var filteredClinics: [VetClinic] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var hasSearched = false
    private var searchBarIsEmpty: Bool {
        (searchBar.text ?? "").isEmpty
    }
    private var isFiltering: Bool {
        hasSearched && !searchBarIsEmpty
    }

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
            title: "Sort",
            systemIconName: "arrow.up.arrow.down"),
            target: self,
            action: #selector(sortTapped)
        )
    private lazy var filterButton = Buttons(
        style: .actionButtonStyle(
            title: "Filter",
            systemIconName: "slider.horizontal.3"),
            target: self,
            action: #selector(filterTapped)
        )
    private lazy var mapButton    = Buttons(
        style: .actionButtonStyle(
            title: "Map",
            systemIconName: "map"),
            target: self,
            action: #selector(mapTapped)
        )
    
    // MARK: - UITableView
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

    // MARK: - Private Properties - Others
    private let backgroundImageView = Images(style: .imageForBackground(name: "bird"))
    
    private let nothingFoundLabel: Labels = {
        let label = Labels(style: .stubLabelStyle)
        label.text = String(localized: "nothing_found")
        label.isHidden = true
        return label
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let loadingView = LoadingView()
    
    // MARK: - Initializers
    init(clinicService: VetClinicService = MockVetClinicService()) {
        self.clinicService = clinicService
        super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
        setupSearchBar()
        setupInitialState()
        fetchClinics()
    }
    
    // MARK: - Private Functions - SearchBar
    private func fetchClinics() {
        clinicService.fetchClinics { [weak self] clinics in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.vetClinics = clinics
            }
        }
    }
    
    private func setupSearchBar() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.systemFont(ofSize: 17)
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.textColor = .label
            textField.backgroundColor = UIColor.secondarySystemBackground
            textField.clearButtonMode = .whileEditing
        }
        definesPresentationContext = true
    }

    // MARK: - Private Functions
    private func setupInitialState() {
//        backgroundImageView.image = UIImage(named: "bird")
        updateUIState()
    }
    
    private func updateUIState() {
        let noResults  = isFiltering && filteredClinics.isEmpty
        let hasResults = isFiltering && !filteredClinics.isEmpty
        
        backgroundImageView.image = UIImage(
            named: noResults
            ? "dogNothingFound"
            : hasResults
            ? "butterfly"
            : "bird"
        )
    
        nothingFoundLabel.isHidden = !noResults
        tableView.isHidden        = !hasResults
        actionsStackView.isHidden = !hasResults
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        hasSearched = true
        
        loadingView.show()
        nothingFoundLabel.isHidden = true
        tableView.isHidden = true
        actionsStackView.isHidden = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
//            Thread.sleep(forTimeInterval: 1.0)
            
            let results: [VetClinic]
            if searchText.isEmpty {
                results = self.vetClinics
            } else {
                results = self.vetClinics.filter { clinic in
                    clinic.name.lowercased().contains(searchText.lowercased()) ||
                    clinic.address.lowercased().contains(searchText.lowercased())
                }
            }
            
            DispatchQueue.main.async {
                self.filteredClinics = results
                self.updateUIState()
                self.loadingView.hide()
            }
        }
    }
    
    // MARK: - Event Handler (Actions)
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func sortTapped() { /* TODO */ }
    @objc private func filterTapped() { /* TODO */ }
    @objc private func mapTapped() { /* TODO */ }
}

// MARK: - Layout
extension SearchViewController {
    private func setupViewsAndConstraints() {
        view.addGestureRecognizer(tapGesture)

        [backgroundImageView, searchBar, actionsStackView, tableView, nothingFoundLabel, loadingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [sortButton, filterButton, mapButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            actionsStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            actionsStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            actionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionsStackView.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nothingFoundLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
            nothingFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContentForSearchText("")
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
        ) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: clinic) { [weak self] updated in
            self?.clinicService.updateBookmark(updated, isBookmarked: updated.isBookmarked) {
                self?.filteredClinics[indexPath.row] = updated
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
            self?.filteredClinics[indexPath.row] = updatedClinic
            self?.clinicService.updateBookmark(
                updatedClinic,
                isBookmarked: updatedClinic.isBookmarked
            ) {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
