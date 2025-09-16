//
//  HealthRecordsViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.9.2025.
//

import UIKit
import PhotosUI

final class HealthRecordsViewController: UIViewController {

    // MARK: - Public
    private let initialFormData: PetProfileFormData
    private let editingProfileId: UUID?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    private let contentStackView = UIStackView()

    private let headerContainerView = UIView()
    private let headerHStack = UIStackView()
    private let avatarImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    private let nameLabel = Labels(style: .bold34TitleLabelStyle)
    private let sectionTitleLabel: Labels = {
        let l = Labels(style: .bold20LabelStyle, text: String(localized: "health_records_title", defaultValue: "Health Records"))
        l.textAlignment = .center
        return l
    }()

    private let listStackView = StackViews(style: .verticall6StackView2)

    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title", defaultValue: "Done")),
        target: self,
        action: #selector(doneTapped)
    )

    // MARK: - Rows (без действий, только UI)
    private lazy var vaccinationsRow = AssetMenuRow(
        title: String(localized: "vaccinations_title", defaultValue: "Vaccinations"),
        assetIconName: "syringe",
        target: self,
        action: #selector(vaccinationsTapped)
    )
    private lazy var rabiesTiterRow = AssetMenuRow(
        title: String(localized: "rabies_titer_title", defaultValue: "Rabies Titer Test"),
        assetIconName: "flask",
        target: self,
        action: #selector(rabiesTiterTapped)
    )
    private lazy var otherLabTestsRow = AssetMenuRow(
        title: String(localized: "other_lab_tests_title", defaultValue: "Other Lab Tests"),
        assetIconName: "flask",
        target: self,
        action: #selector(otherLabTestsTapped)
    )
    private lazy var parasiteTreatmentsRow = AssetMenuRow(
        title: String(localized: "parasite_treatments_title", defaultValue: "Parasite Treatments"),
        assetIconName: "parasite",
        target: self,
        action: #selector(parasiteTreatmentsTapped)
    )
    private lazy var allergiesRow = AssetMenuRow(
        title: String(localized: "allergies_title", defaultValue: "Allergies"),
        assetIconName: "pill",
        target: self,
        action: #selector(allergiesTapped)
    )
    private lazy var medicalConditionsRow = AssetMenuRow(
        title: String(localized: "medical_conditions_title", defaultValue: "Medical Conditions"),
        assetIconName: "cross.case",
        target: self,
        action: #selector(medicalConditionsTapped)
    )
    private lazy var clinicalExamsRow = AssetMenuRow(
        title: String(localized: "clinical_examinations_title", defaultValue: "Clinical Examinations"),
        assetIconName: "virus",
        target: self,
        action: #selector(clinicalExamsTapped)
    )
    private lazy var surgeriesRow = AssetMenuRow(
        title: String(localized: "surgeries_procedures_title", defaultValue: "Surgeries / Procedures"),
        assetIconName: "scalpel",
        target: self,
        action: #selector(surgeriesTapped)
    )
    private lazy var vetVisitsRow = AssetMenuRow(
        title: String(localized: "vet_visits_title", defaultValue: "Vet visits"),
        assetIconName: "calendar.badge.clock",
        target: self,
        action: #selector(vetVisitsTapped)
    )
    private lazy var symptomsRow = AssetMenuRow(
        title: String(localized: "symptoms_observations_title", defaultValue: "Symptoms & Observations"),
        assetIconName: "symptoms",
        target: self,
        action: #selector(symptomsTapped)
    )

    // MARK: - Init
    init(formData: PetProfileFormData, editingProfileID: UUID? = nil) {
        self.initialFormData = formData
        self.editingProfileId = editingProfileID
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupViewsAndConstraints()
        fillHeader()
    }

    private func setupNavigation() {
        // Слева — системная Back появится автоматически при push
        // Справа — крестик, чтобы закрыть весь поток, если модально
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeButton
    }

    private func fillHeader() {
        nameLabel.text = initialFormData.name.nilIfBlank
            ?? String(localized: "name_title", defaultValue: "Name")

        if let data = initialFormData.avatarImageData, let img = UIImage(data: data) {
            avatarImageView.image = img
        } else if let file = initialFormData.avatarFileName {
            // в проекте есть хелпер UIImage.loadOrPlaceholder; используем его, если доступен
            if let image = UIImage.loadOrPlaceholder(named: file, in: traitCollection) {
                avatarImageView.image = image
            } else {
                avatarImageView.image = UIImage(named: "no photo")
            }
        } else {
            avatarImageView.image = UIImage(named: "no photo")
        }
    }
}

// MARK: - Layout
private extension HealthRecordsViewController {
    func setupViewsAndConstraints() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        view.addSubview(bottomBarContainerView)
        scrollView.addSubview(contentContainerView)
        contentContainerView.addSubview(contentStackView)

        // Контентный стек
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        // Header
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerHStack.translatesAutoresizingMaskIntoConstraints = false
        headerHStack.axis = .horizontal
        headerHStack.alignment = .center
        headerHStack.spacing = 16
        headerContainerView.addSubview(headerHStack)

        let avatarSide: CGFloat = 80
        avatarImageView.layer.cornerRadius = avatarSide / 2

        headerHStack.addArrangedSubview(avatarImageView)
        headerHStack.addArrangedSubview(nameLabel)

        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.lineBreakMode = .byTruncatingTail

        // Секции в контентный стек
        contentStackView.addArrangedSubview(headerContainerView)
        contentStackView.addArrangedSubview(sectionTitleLabel)
        contentStackView.addArrangedSubview(listStackView)

        // Список карточек (каждый ряд в скруглённом фоне)
        [
            vaccinationsRow,
            rabiesTiterRow,
            otherLabTestsRow,
            parasiteTreatmentsRow,
            allergiesRow,
            medicalConditionsRow,
            clinicalExamsRow,
            surgeriesRow,
            vetVisitsRow,
            symptomsRow
        ]
            .map { wrapRowInRoundedBackground($0) }
            .forEach { listStackView.addArrangedSubview($0) }

        // Кнопка Done
        let readable = bottomBarContainerView.readableContentGuide
        bottomBarContainerView.addSubview(doneButton)

        // Констрейнты
        NSLayoutConstraint.activate([
            // Scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarContainerView.topAnchor),

            // Контейнер контента
            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // Внутренний стек
            contentStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16),

            // Header
            headerHStack.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerHStack.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            headerHStack.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            headerHStack.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainerView.leadingAnchor),
            headerHStack.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),

            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),

            // Нижний бар
            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            doneButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            doneButton.topAnchor.constraint(equalTo: bottomBarContainerView.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
            doneButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
            doneButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }

    func wrapRowInRoundedBackground(_ row: UIControl) -> UIView {
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
}

// MARK: - Event Handler (Actions)
private extension HealthRecordsViewController {
    @objc func closeTapped() {
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func doneTapped() {
        // Пока только закрываем экран (без сохранения)
        closeTapped()
    }

    // Плейсхолдеры — действия добавим позже
    @objc func vaccinationsTapped() {
//        let list = VaccinationsListViewController(
//            petDisplayName: initialFormData.name.nilIfBlank
//            ?? String(localized: "name_title", defaultValue: "Name"),
//            petAvatarImageData: initialFormData.avatarImageData,
//            petAvatarFileName: initialFormData.avatarFileName,
//            petId: editingProfileId
//        )
//        navigationController?.pushViewController(list, animated: true)
        guard let editingProfileId = editingProfileId else {
            assertionFailure("editingProfileId is nil — должен приходить PetProfileCoreData.id")
            return
        }
        
        let list = VaccinationsListViewController(
            petDisplayName: initialFormData.name.nilIfBlank
            ?? String(localized: "name_title", defaultValue: "Name"),
            petAvatarImageData: initialFormData.avatarImageData,
            petAvatarFileName: initialFormData.avatarFileName,
            petId: editingProfileId                 // ← сюда кладём именно PetProfileCoreData.id
        )
        navigationController?.pushViewController(list, animated: true)
    }
    
    @objc func rabiesTiterTapped()         {}
    @objc func otherLabTestsTapped()       {}
    @objc func parasiteTreatmentsTapped()  {}
    @objc func allergiesTapped()           {}
    @objc func medicalConditionsTapped()   {}
    @objc func clinicalExamsTapped()       {}
    @objc func surgeriesTapped()           {}
    @objc func vetVisitsTapped()           {}
    @objc func symptomsTapped()            {}
}
