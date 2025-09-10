//
//  CreatePetProfileViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 20.8.2025.
//

import UIKit
import PhotosUI

final class CreatePetProfileViewController: UIViewController {
    
    private var formData = PetProfileFormData(
        name: "",
        fullName: nil,
        sex: nil,
        species: .other(""),
        breed: nil,
        colorMarkings: nil,
        dateOfBirth: nil,
        weightInKilograms: nil,
        identificationType: .none,
        identificationNumber: nil,
        avatarImageData: nil,
        avatarFileName: nil
    )
    
    private let contentContainerView = UIView()
    
    private let photoContainerView = Views(style: .view12Style2)
    private let photoTitleLabel: Labels = {
        let raw = String(localized: "upload_photo_title", defaultValue: "Upload photo")
        let multiline = raw.replacingOccurrences(of: " ", with: "\n")
        return Labels(style: .ordinaryText13LabelStyle2, text: multiline)
    }()
    
    private let formStackView = StackViews(style: .verticall6StackView2)
    
    private lazy var generalInfoRow = MenuRow(
        title: String(localized: "general_info_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "doc.text",
        target: self,
        action: #selector(generalInfoTapped)
    )
    private lazy var ownersRow = MenuRow(
        title: String(localized: "owners_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "person.2",
        target: self,
        action: #selector(ownersTapped)
    )
    private lazy var nutritionRow = MenuRow(
        title: String(localized: "nutrition_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "fork.knife",
        target: self,
        action: #selector(nutritionTapped)
    )
    private lazy var healthRecordsRow = MenuRow(
        title: String(localized: "health_records_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "folder.badge.plus",
        target: self,
        action: #selector(healthRecordsTapped)
    )
    private lazy var notesRow = MenuRow(
        title: String(localized: "notes_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "note.text",
        target: self,
        action: #selector(notesTapped)
    )
    private lazy var photosRow = MenuRow(
        title: String(localized: "photos_title"),
        labelStyle: .ordinaryText17LabelStyle,
        leadingSystemIconName: "photo.on.rectangle",
        target: self,
        action: #selector(photosTapped)
    )
    
    private let avatarPreviewImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title")),
        target: self,
        action: #selector(doneTapped)
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupViewsAndConstraints()
        configurePhotoPicking()
        refreshAvatarPreview()
    }
    
    // MARK: - Private
    
    private func setupNavigation() {
        let closeButton = Buttons(
            style: .actionButtonStyle(title: "", systemIconName: "xmark"),
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    private func wrapRowInRoundedBackground(_ row: UIControl) -> UIView {
        let container = Views(style: .view12Style)
        container.backgroundColor = .secondarySystemBackground
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        return container
    }
    
    private func configurePhotoPicking() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickPhotoTapped))
        photoContainerView.isUserInteractionEnabled = true
        photoContainerView.addGestureRecognizer(tap)
    }
    
    private func handlePickedImage(_ image: UIImage) {
        let resized = image.resizedToFit(maxDimension: 1024)
        let data = resized.jpegData(compressionQuality: 0.8)
        formData.avatarImageData = data
        refreshAvatarPreview()
    }
    
    private func refreshAvatarPreview() {
        if let data = formData.avatarImageData, let img = UIImage(data: data) {
            avatarPreviewImageView.image = img
            photoTitleLabel.isHidden = true
        } else {
            avatarPreviewImageView.image = UIImage(named: "no photo")
            photoTitleLabel.isHidden = false
        }
    }
    
    
    // MARK: - Event Handler (Actions)
    @objc private func closeTapped() {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func doneTapped() {
        // 1) простая валидация
        formData.name = formData.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !formData.name.isEmpty else {
            let alert = UIAlertController(
                title: String(localized: "name_required_title", defaultValue: "Name required"),
                message: String(localized: "name_required_msg", defaultValue: "Please fill in pet’s name in General info."),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let speciesIsValid: Bool = {
            switch formData.species {
            case .cat, .dog: return true
            case .other(let custom):
                return !custom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        }()
        guard speciesIsValid else {
            let alert = UIAlertController(
                title: String(localized: "species_required_title", defaultValue: "Species required"),
                message: String(localized: "species_required_msg", defaultValue: "Please select the pet’s species in General info."),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 2) временно блокируем кнопку, чтобы не задвоить сохранение
        doneButton.isEnabled = false
        
        // 3) сохраняем в Core Data
        PetProfilesStorage.shared.create(from: formData) { [weak self] ok in
            DispatchQueue.main.async {
                guard let self else { return }
                if ok {
                    // Репозиторий уже шлёт Notification .petProfilesStorageDidChange — списки могут обновиться.
                    self.closeTapped() // ← закрываем ТОЛЬКО при успехе
                } else {
                    self.doneButton.isEnabled = true
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Could not save profile. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    @objc private func generalInfoTapped() {
        let viewController = PetGeneralInfoViewController(initial: formData)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // CreatePetProfileViewController.swift
    @objc private func ownersTapped() {
        let viewController = OwnersViewController(
            initialOwners: formData.owners.map { $0.asOwnersVCFormData() }
        )
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func nutritionTapped()   { /* TODO */ }
    @objc private func healthRecordsTapped(){ /* TODO */ }
    @objc private func notesTapped()       { /* TODO */ }
    @objc private func photosTapped()      { /* TODO */ }
    
    @objc private func pickPhotoTapped() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            present(picker, animated: true)
        }
    }
}

// MARK: - Layout
extension CreatePetProfileViewController {
    private func setupViewsAndConstraints() {
        
        let readable = bottomBarContainerView.readableContentGuide
        
        
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentContainerView)
        view.addSubview(bottomBarContainerView)
        
        // Контент
        contentContainerView.addSubview(photoContainerView)
        photoContainerView.addSubview(avatarPreviewImageView)
        photoContainerView.addSubview(photoTitleLabel)
        contentContainerView.addSubview(formStackView)
        
        [
            wrapRowInRoundedBackground(generalInfoRow),
            wrapRowInRoundedBackground(ownersRow),
            wrapRowInRoundedBackground(nutritionRow),
            wrapRowInRoundedBackground(healthRecordsRow),
            wrapRowInRoundedBackground(notesRow),
            wrapRowInRoundedBackground(photosRow)
        ].forEach { formStackView.addArrangedSubview($0) }
        
        bottomBarContainerView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomBarContainerView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            photoContainerView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 24),
            photoContainerView.centerXAnchor.constraint(equalTo: contentContainerView.centerXAnchor),
            photoContainerView.widthAnchor.constraint(equalToConstant: 112),
            photoContainerView.heightAnchor.constraint(equalToConstant: 112),
            
            avatarPreviewImageView.topAnchor.constraint(equalTo: photoContainerView.topAnchor),
            avatarPreviewImageView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            avatarPreviewImageView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            avatarPreviewImageView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor),
            
            photoTitleLabel.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            photoTitleLabel.centerYAnchor.constraint(equalTo: photoContainerView.centerYAnchor),
            
            formStackView.topAnchor.constraint(equalTo: photoContainerView.bottomAnchor, constant: 24),
            formStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
            formStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
            formStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            
            doneButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
    
            doneButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
            
            doneButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
        photoContainerView.layer.masksToBounds = true
        photoContainerView.layer.cornerRadius = 56
        avatarPreviewImageView.layer.cornerRadius = 56
    }
}

extension CreatePetProfileViewController: PetGeneralInfoViewControllerDelegate {
    func petGeneralInfoViewController(_ controller: PetGeneralInfoViewController,
                                      didFinishWith data: PetProfileFormData) {
        self.formData = data
        
        let review = ReviewPetProfileViewController(formData: data)
        review.onEditGeneralInfo = { [weak self] in
            guard let self else { return }
            let vc = PetGeneralInfoViewController(initial: self.formData)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // Заменяем General info в стеке на Review, чтобы «Назад» вернул в Create
        if let nav = navigationController {
            nav.setViewControllers([self, review], animated: true)
        }
    }
}

@available(iOS 14, *)
extension CreatePetProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self, let image = object as? UIImage else { return }
            DispatchQueue.main.async { self.handlePickedImage(image) }
        }
    }
}

extension CreatePetProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        let image = (info[.editedImage] ?? info[ .originalImage]) as? UIImage
        if let image { handlePickedImage(image) }
    }
}

extension CreatePetProfileViewController: OwnersViewControllerDelegate {
    func ownersViewController(_ controller: OwnersViewController,
                              didFinishWith owners: [OwnersViewController.OwnerFormData]) {
        // сохраняем в форму (фильтруем полностью пустые слоты)
        self.formData.owners = owners
            .map { $0.asPetOwnerFormData() }
//            .filter { !$0.isEmpty }
    }
}
