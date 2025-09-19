//
//  PetClinicsViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 4.6.2025.
//

import UIKit

final class MyPetClinicsViewController: UIViewController {

    // MARK: - Dependencies
    private let clinicService: VetClinicService

    // MARK: - UI
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier
        )
        return tableView
    }()

    private let emptyStateView = EmptyStateView()

    // MARK: - Data
    private var bookmarkedClinics: [VetClinic] = [] {
        didSet { updateUI() }
    }

    // MARK: - Init
    
    init(clinicService: VetClinicService) {
        self.clinicService = clinicService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBookmarksChanged),
            name: .vetClinicBookmarksDidChange,
            object: nil
        )

        loadBookmarkedClinics()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarkedClinics()
    }

    // MARK: - Private
    
    private func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.text = String(localized: "myPetClinics_title", defaultValue: "My Pet Clinics")
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupViewsAndConstraints() {
        [tableView, emptyStateView].forEach { view.addSubview($0) }
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
        
        emptyStateView.configure(mode: .textOnly)
        emptyStateView.setTexts(
            title: String(localized: "no_bookmarks_title", defaultValue: "No clinics yet"),
            subtitle: String(localized: "no_bookmarks_message",
                             defaultValue: "Tap the bookmark icon on a clinic to add it here")
        )
        emptyStateView.setTextColors(primary: .label, secondary: .secondaryLabel)
    }
    
    private func updateUI() {
        let isEmpty = bookmarkedClinics.isEmpty
        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }

    private func loadBookmarkedClinics() {
        clinicService.fetchClinics { [weak self] allClinics in
            DispatchQueue.main.async {
                self?.bookmarkedClinics = allClinics.filter { $0.isBookmarked }
                self?.tableView.reloadData()
            }
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        return rc
    }()
    
    // MARK: - Event Handler (Actions)
    
    @objc private func refreshPulled() {
        clinicService.fetchClinics { [weak self] allClinics in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.bookmarkedClinics = allClinics.filter { $0.isBookmarked }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func handleBookmarksChanged() {
        loadBookmarkedClinics()
    }
}

// MARK: - UITableViewDataSource
extension MyPetClinicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkedClinics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clinic = bookmarkedClinics[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchResultTableViewCell else { return UITableViewCell() }

        cell.configure(with: clinic) { [weak self] updatedClinic in
            guard let self = self else { return }
            self.clinicService.updateBookmark(updatedClinic, isBookmarked: updatedClinic.isBookmarked) {
                DispatchQueue.main.async {
                    if !updatedClinic.isBookmarked,
                       let removeIndex = self.bookmarkedClinics.firstIndex(where: { $0.id == updatedClinic.id }) {
                        self.bookmarkedClinics.remove(at: removeIndex)
                        tableView.deleteRows(at: [IndexPath(row: removeIndex, section: 0)], with: .automatic)
                        self.updateUI()
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyPetClinicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let clinic = bookmarkedClinics[indexPath.row]

        let detailsViewController = ClinicDetailsViewController(
            clinic: clinic,
            clinicService: clinicService
        ) { [weak self] updatedClinic in
            guard let self = self else { return }
            self.clinicService.updateBookmark(updatedClinic, isBookmarked: updatedClinic.isBookmarked) {
                DispatchQueue.main.async {
                    if !updatedClinic.isBookmarked,
                       let removeIndex = self.bookmarkedClinics.firstIndex(where: { $0.id == updatedClinic.id }) {
                        self.bookmarkedClinics.remove(at: removeIndex)
                        tableView.deleteRows(at: [IndexPath(row: removeIndex, section: 0)], with: .automatic)
                        self.updateUI()
                    } else if let updateIndex = self.bookmarkedClinics.firstIndex(where: { $0.id == updatedClinic.id }) {
                        self.bookmarkedClinics[updateIndex] = updatedClinic
                        tableView.reloadRows(at: [IndexPath(row: updateIndex, section: 0)], with: .none)
                    }
                }
            }
        }
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let remove = UIContextualAction(style: .destructive,
                                        title: String(localized: "Remove")) { [weak self] _, _, finish in
            guard let self = self else { finish(false); return }
            
            // Берем клинику и готовим обновление
            let clinic = self.bookmarkedClinics[indexPath.row]
            var updated = clinic
            updated.isBookmarked = false
            
            if let currentIdx = self.bookmarkedClinics.firstIndex(where: { $0.id == clinic.id }) {
                self.bookmarkedClinics.remove(at: currentIdx)
                tableView.deleteRows(at: [IndexPath(row: currentIdx, section: 0)], with: .automatic)
                self.updateUI()
            }
            
            self.clinicService.updateBookmark(updated, isBookmarked: false) {
                DispatchQueue.main.async { finish(true) }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
