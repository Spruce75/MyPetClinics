//
//  ProfileViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 4.6.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.register(PetTableViewCell.self, forCellReuseIdentifier: PetTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var searchButton = Buttons(
        style: .actionButtonStyle(title: "", systemIconName: "magnifyingglass"),
        target: self,
        action: #selector(searchTapped)
    )
    
    private lazy var addButton: Buttons = {
        let button = Buttons(
            style: .actionButtonStyle(title: "", systemIconName: "plus"),
            target: self,
            action: #selector(addTapped)
        )
        button.tintColor = .systemBlue
        return button
    }()
    
    // MARK: - Data
    private var profiles: [PetProfile] = []
    private var pets: [Pet] = []
    private var orderedIDs: [UUID] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitle()
        setupViewsAndConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleStorageDidChange),
            name: .petProfilesStorageDidChange,
            object: nil
        )
        
        reloadPetsFromStorage()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
//    private func reloadPetsFromStorage() {
//        profiles = PetProfilesStorage.shared.fetchAll()
//        pets = profiles.map(Pet.init(from:))
//        tableView.reloadData()
//    }
    
    private func reloadPetsFromStorage() {
        let fetched = PetProfilesStorage.shared.fetchAll()
        let dict = Dictionary(uniqueKeysWithValues: fetched.map { ($0.id, $0) })
        
        if orderedIDs.isEmpty {
            // фиксируем первоначальный порядок и далее его держим
            orderedIDs = fetched.map { $0.id }
        } else {
            // убираем из порядка удалённых
            orderedIDs.removeAll { dict[$0] == nil }
            // добавляем в конец новых (созданных) по порядку прихода
            for p in fetched where !orderedIDs.contains(p.id) {
                orderedIDs.append(p.id)
            }
        }
        
        profiles = orderedIDs.compactMap { dict[$0] }
        pets = profiles.map(Pet.init(from:))
        tableView.reloadData()
    }
    
    
    private func setupTitle() {
        let titleLabel = Labels(
            style: .bold17LabelStyle,
            text: String(localized: "my_pets_title", defaultValue: "My Pets")
        )
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        addButton.tintColor = .systemBlue
        
        let edgeInset: CGFloat = 30
        let leftSpacer  = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpacer.width = edgeInset
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpacer.width = edgeInset
        
        // слева: spacer потом кнопка (раскладка слева-направо)
        navigationItem.leftBarButtonItems = [
            leftSpacer,
            UIBarButtonItem(customView: searchButton)
        ]
        
        // справа: СНАЧАЛА spacer, затем кнопка (раскладка справа-налево)
        navigationItem.rightBarButtonItems = [
            rightSpacer,
            UIBarButtonItem(customView: addButton)
        ]
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    // MARK: - Event Handler (Actions)
    
    @objc private func handleStorageDidChange() {
        reloadPetsFromStorage()
    }
    
    @objc private func searchTapped() {
        // TODO: поиск по питомцам
    }
    @objc private func addTapped() {
        let createProfileViewController = CreatePetProfileViewController()
        let navigationController = UINavigationController(rootViewController: createProfileViewController)
        
        if #available(iOS 15.0, *),
           let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            navigationController.modalPresentationStyle = .fullScreen
        }
        present(navigationController, animated: true)
    }

}

// MARK: - Layout
private extension ProfileViewController {
    func setupViewsAndConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,  constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PetTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? PetTableViewCell else {
            return UITableViewCell()
        }
        let pet = pets[indexPath.row]
        cell.configure(with: pet, traitCollection: traitCollection)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let pet = pets[indexPath.row]
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .systemBackground
//        viewController.title = pet.name
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let profile = profiles[indexPath.row]
        let formData = PetProfileFormData(from: profile)
        
        // передаём ID, чтобы Review понимал: это редактирование, а не создание
        let review = ReviewPetProfileViewController(formData: formData, editingProfileID: profile.id)
        
        review.onEditGeneralInfo = { [weak review] in
            guard let review else { return }
            let editVC = PetGeneralInfoViewController(initial: review.formData)
            editVC.delegate = review
            review.navigationController?.pushViewController(editVC, animated: true)
        }
        
        navigationController?.pushViewController(review, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: String(localized: "delete_title", defaultValue: "Delete")
        ) { [weak self] _, _, completion in
            self?.confirmDelete(at: indexPath)
            completion(true)
        }

        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}


private extension ProfileViewController {
    
    func confirmDelete(at indexPath: IndexPath) {
        let pet = pets[indexPath.row]
        
        let alert = UIAlertController(
            title: String(localized: "delete_pet_title", defaultValue: "Delete pet?"),
            message: String(localized: "delete_pet_msg",
                            defaultValue: "“\(pet.name)” will be removed from your pets."),
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: String(localized: "cancel_title", defaultValue: "Cancel"), style: .cancel))
        
        alert.addAction(UIAlertAction(title: String(localized: "delete_title", defaultValue: "Delete"),
                                      style: .destructive,
                                      handler: { [weak self] _ in
            guard let self else { return }
            
            // Оптимистично анимируем удаление строки
            let removedPet = self.pets.remove(at: indexPath.row)
            self.orderedIDs.removeAll { $0 == removedPet.id }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            PetProfilesStorage.shared.delete(by: removedPet.id) { success in
                if !success {
                    // Если не удалось — покажем ошибку и восстановим список из базы
                    let errorAlert = UIAlertController(
                        title: String(localized: "error_title", defaultValue: "Error"),
                        message: String(localized: "delete_failed_msg",
                                        defaultValue: "Could not delete the pet. Please try again."),
                        preferredStyle: .alert
                    )
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                    self.reloadPetsFromStorage()
                }
                // При успехе список всё равно обновится через нотификацию стораджа.
            }
        }))
        
        // iPad popover anchor
        if let cell = tableView.cellForRow(at: indexPath) {
            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = cell.bounds
        }
        
        present(alert, animated: true)
    }
}
