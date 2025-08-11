//
//  FiltersViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 30.7.2025.
//

import UIKit

// MARK: - FiltersViewController

final class FiltersViewController: UIViewController {
    // MARK: - Public Properties
    var onFilterOptionsSave: ((Set<String>) -> Void)?
    
    // MARK: - Private Properties
    private var chosenFilterOptions: Set<String> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var preselectedOptions: Set<String> = []

    private lazy var closeButton = Buttons(
        style: .actionButtonStyle(
            title: "",
            systemIconName: "xmark"
        ),
        target: self,
        action: #selector(closeTapped)
    )

    private let titleLabel: Labels = {
        let label = Labels(style: .bold17LabelStyle)
        label.text = String(localized: "filters_title")
        return label
    }()

    private lazy var clearAllButton = Buttons(
        style: .actionButtonStyle(
            title: String(localized: "clear_all_title"),
            systemIconName: ""
        ),
        target: self,
        action: #selector(clearAllTapped)
    )
    
    private let filterSections: [FilterSection] = FilterConfigurationProvider.defaultSections()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.clipsToBounds = true
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
        tableView.allowsSelection = false
        return tableView
    }()

    private lazy var showResultsButton = Buttons(
        style: .primary(
            title: String(localized: "show_results_title")
        ),
        target: self,
        action: #selector(showResultsTapped)
    )

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chosenFilterOptions = preselectedOptions
    }
    
    // MARK: - Private Methods
    
    func setSelectedOptions(_ options: Set<String>) {
        preselectedOptions = options
        chosenFilterOptions = options
    }
    
    func makeSectionHeaderView(with title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        let label = Labels(style: .sectionHeaderLabelStyle, text: title)
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        return container
    }

    // MARK: - Event Handler (Actions)
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func clearAllTapped() {
        chosenFilterOptions.removeAll()
    }

    @objc private func showResultsTapped() {
        onFilterOptionsSave?(chosenFilterOptions)
        dismiss(animated: true)
    }
}

// MARK: - Layout
extension FiltersViewController {
    
    private func setupViewsAndConstraints() {
        [closeButton, titleLabel, clearAllButton, tableView, showResultsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearAllButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            clearAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // TableView
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: showResultsButton.topAnchor, constant: -12),
            
            // Show Results Button
            showResultsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showResultsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            showResultsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            showResultsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        filterSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterSections[section].options.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        let option = filterSections[indexPath.section].options[indexPath.row]
        let isOn = chosenFilterOptions.contains(option.name)
        cell.configure(text: option.name, isOn: isOn)
        cell.switchValueChanged = { [weak self] text, isOn in
            guard let self = self else { return }
            if isOn {
                self.chosenFilterOptions.insert(option.name)
            } else {
                self.chosenFilterOptions.remove(option.name)
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        filterSections[section].title
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        32
    }
}
