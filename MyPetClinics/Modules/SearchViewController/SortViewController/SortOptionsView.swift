//
//  SortOptionsView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.7.2025.
//

import UIKit

protocol SortOptionsViewControllerDelegate: AnyObject {
    func sortOptionsViewController(
        _ controller: SortViewController,
        didSelectOptionAt index: Int
    )
}

final class SortViewController: UIViewController {
    
    weak var delegate: SortOptionsViewControllerDelegate?
    var options: [String] = []
    var selectedIndex: Int?
    
    // MARK: - Subviews
    private let titleLabel: Labels = {
        let label = Labels(style: .bold17LabelStyle)
        label.text = String(localized: "sort_by_title")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        return tableView
    }()
    
    private let applyButton = Buttons(
        style: .primary(title: String(localized: "apply_title")),
    )
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func applyTapped() {
        guard let index = selectedIndex else { return }
        delegate?.sortOptionsViewController(self, didSelectOptionAt: index)
        dismiss(animated: true)
    }
}

// MARK: - Layout
private extension SortViewController {
    func setupViewsAndConstraints() {
        [titleLabel, tableView, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -8),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SortViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = (
            indexPath.row == selectedIndex
            ? .systemBlue
            : .label
        )
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
