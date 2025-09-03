//
//  ReviewPetProfileViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 2.9.2025.
//

import UIKit

/// Экран-резюме после заполнения General info.
/// Показывает имя/аватар слева и сводку полей, ниже — секции Owners/Nutrition/... и кнопку Done для сохранения.
final class ReviewPetProfileViewController: UIViewController {

    // MARK: Inputs
    private(set) var formData: PetProfileFormData
    var onEditGeneralInfo: (() -> Void)?
    var showsDoneButton: Bool = true
    
    private let editingProfileID: UUID?
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    // MARK: UI
    private let headerContainerView = UIView()
    private let avatarImageView = Images(style: .imageForBackground(name: "no photo"))
    private let nameTitleLabel = Labels(style: .bold34TitleLabelStyle)

    private let summaryCardView = FormCardView()
    private let summaryStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .fill
        s.spacing = 0
        return s
    }()
    private let primarySummaryLabel   = Labels(style: .ordinaryText17LabelStyle) // Full name, Sex, Age
    private let secondarySummaryLabel = Labels(style: .ordinaryText17LabelStyle) // Species, Weight
    private let breedRow = KeyValueRowView()
    private let colorRow = KeyValueRowView()
    private let dobRow   = KeyValueRowView()
    private let idRow    = KeyValueRowView()

    private let formStackView = StackViews(style: .verticall6StackView2)
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

    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title")),
        target: self,
        action: #selector(doneTapped)
    )

    // MARK: Init
    init(formData: PetProfileFormData, editingProfileID: UUID? = nil) {
        self.formData = formData
        self.editingProfileID = editingProfileID
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNav()
        setupLayout()
        refreshSummary()
        
        if !showsDoneButton {
            bottomBarContainerView.isHidden = true
        }
    }

//    private func setupNav() {
//        // Крестик слева — закрыть всё
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "xmark"),
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//        // Кнопка «редактировать General info»
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "square.and.pencil"),
//            style: .plain,
//            target: self,
//            action: #selector(editGeneralInfoTapped)
//        )
//    }
    
    private func setupNav() {
        // Если модально — крестик, если пушем в навигации — системная Back
        if let nav = navigationController, nav.presentingViewController != nil || presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: self,
                action: #selector(closeTapped)
            )
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editGeneralInfoTapped)
        )
    }

    // MARK: Layout
    private func setupLayout() {
        // Scroll
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Контейнер контента внутри скролла (будет одной ширины с экраном)
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Стек с контентом
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStack)

        // Добавляем секции в стек
        [headerContainerView, summaryCardView, formStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview($0)
        }

        // Нижний бар с кнопкой Done
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarContainerView)

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.addSubview(doneButton)

        // --- ВНУТРЕННИЕ КОНСТРЕЙНТЫ header/summary как раньше ---
        avatarImageView.clipsToBounds = true
        let avatarSize: CGFloat = 64
        avatarImageView.layer.cornerRadius = avatarSize / 2

        [avatarImageView, nameTitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerContainerView.addSubview($0)
        }

        summaryStackView.translatesAutoresizingMaskIntoConstraints = false
        summaryCardView.addSubview(summaryStackView)

        // «Текстовые» контейнеры (как было)
        let primaryContainer = UIView()
        let secondaryContainer = UIView()
        [primaryContainer, secondaryContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        primarySummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondarySummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryContainer.addSubview(primarySummaryLabel)
        secondaryContainer.addSubview(secondarySummaryLabel)

        // --- АКТИВАЦИЯ КОНСТРЕЙНТОВ ---

        let readable = bottomBarContainerView.readableContentGuide
        NSLayoutConstraint.activate([
            // ScrollView занимает всё над нижним баром
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarContainerView.topAnchor),

            // contentView полностью описывает контент скролла
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // ширина контента = ширина экрана (без горизонтального скролла)
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // стек внутри contentView с отступами
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            // Внутренние констрейнты header
            avatarImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize),

            nameTitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameTitleLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),

            headerContainerView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),

            // Внутренние констрейнты summaryCardView
            summaryStackView.topAnchor.constraint(equalTo: summaryCardView.topAnchor, constant: 8),
            summaryStackView.leadingAnchor.constraint(equalTo: summaryCardView.leadingAnchor),
            summaryStackView.trailingAnchor.constraint(equalTo: summaryCardView.trailingAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: summaryCardView.bottomAnchor, constant: -8),

            // Лейблы в своих контейнерах
            primarySummaryLabel.leadingAnchor.constraint(equalTo: primaryContainer.leadingAnchor, constant: 16),
            primarySummaryLabel.trailingAnchor.constraint(equalTo: primaryContainer.trailingAnchor, constant: -16),
            primarySummaryLabel.centerYAnchor.constraint(equalTo: primaryContainer.centerYAnchor),

            secondarySummaryLabel.leadingAnchor.constraint(equalTo: secondaryContainer.leadingAnchor, constant: 16),
            secondarySummaryLabel.trailingAnchor.constraint(equalTo: secondaryContainer.trailingAnchor, constant: -16),
            secondarySummaryLabel.centerYAnchor.constraint(equalTo: secondaryContainer.centerYAnchor),

            // Нижний бар
            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            doneButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            doneButton.topAnchor.constraint(equalTo: bottomBarContainerView.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
            doneButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
            doneButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
        ])

        // Сборка строк в summaryStackView (как было)
        summaryStackView.addArrangedSubview(primaryContainer)
        summaryStackView.addArrangedSubview(FormSeparatorView())
        summaryStackView.addArrangedSubview(secondaryContainer)
        summaryStackView.addArrangedSubview(FormSeparatorView())
        summaryStackView.addArrangedSubview(breedRow)
        summaryStackView.addArrangedSubview(FormSeparatorView())
        summaryStackView.addArrangedSubview(colorRow)
        summaryStackView.addArrangedSubview(FormSeparatorView())
        summaryStackView.addArrangedSubview(dobRow)
        summaryStackView.addArrangedSubview(FormSeparatorView())
        summaryStackView.addArrangedSubview(idRow)

        // Блоки Owners/Nutrition/... (как было)
        [ownersRow, nutritionRow, healthRecordsRow, notesRow, photosRow]
            .map { wrapRowInRoundedBackground($0) }
            .forEach { formStackView.addArrangedSubview($0) }

        // Кнопка гарантированно поверх контента
        view.bringSubviewToFront(bottomBarContainerView)
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
    
    private func refreshSummary() {
        // Имя у аватара
        nameTitleLabel.text = formData.name.nilIfBlank
            ?? String(localized: "name_title", defaultValue: "Name")

        // Считаем тексты
        let fullName  = formData.fullName?.nilIfBlank
        let sexText   = formData.sex?.localizedTitle
        let ageText   = formData.dateOfBirth.map { formattedAge(since: $0) }
        let primary   = [fullName, sexText, ageText].compactMap { $0 }.joined(separator: ", ")

        let speciesText: String? = {
            switch formData.species {
            case .cat: return String(localized: "cat_title", defaultValue: "Cat")
            case .dog: return String(localized: "dog_title", defaultValue: "Dog")
            case .other(let custom):
                let t = custom.trimmingCharacters(in: .whitespacesAndNewlines)
                return t.isEmpty ? nil : t
            }
        }()
        let weightText = formData.weightInKilograms.map { String(format: "%.0f kg", $0) }
        let secondary  = [speciesText, weightText].compactMap { $0 }.joined(separator: ", ")

        // Очищаем стек и собираем заново только непустые блоки
        summaryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var blocks: [UIView] = []

        if !primary.isEmpty {
            primarySummaryLabel.text = primary
            blocks.append(makeTextRowContainer(for: primarySummaryLabel))
        }
        if !secondary.isEmpty {
            secondarySummaryLabel.text = secondary
            blocks.append(makeTextRowContainer(for: secondarySummaryLabel))
        }

        if let v = formData.breed?.nilIfBlank {
            breedRow.configure(title: String(localized: "breed_title", defaultValue: "Breed:"), value: v)
            blocks.append(breedRow)
        }
        if let v = formData.colorMarkings?.nilIfBlank {
            colorRow.configure(title: String(localized: "color_markings_title", defaultValue: "Color:"), value: v)
            blocks.append(colorRow)
        }
        if let date = formData.dateOfBirth {
            let f = DateFormatter(); f.dateStyle = .long
            dobRow.configure(title: String(localized: "dob_title", defaultValue: "Date of birth:"), value: f.string(from: date))
            blocks.append(dobRow)
        }
        if formData.identificationType != .none,
           let number = formData.identificationNumber?.nilIfBlank {
            idRow.configure(title: "ID:", value: "\(formData.identificationType.localizedTitle) \(number)")
            blocks.append(idRow)
        }

        // Вставляем с разделителями между блоками
        for i in 0..<blocks.count {
            summaryStackView.addArrangedSubview(blocks[i])
            if i < blocks.count - 1 {
                summaryStackView.addArrangedSubview(FormSeparatorView())
            }
        }
        
        // если вдруг совсем пусто — можно скрыть карточку
        summaryCardView.isHidden = blocks.isEmpty
        
        avatarImageView.image = UIImage.loadOrPlaceholder(
            named: formData.avatarFileName ?? "no photo",
            in: traitCollection
        )
    }

    // маленький помощник для "текстовых" строк (высота 44)
    private func makeTextRowContainer(for label: UILabel) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 44).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }


    // MARK: Actions
    @objc private func closeTapped() {
        // Закрыть модальную навигацию целиком
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }

    @objc private func editGeneralInfoTapped() {
        onEditGeneralInfo?()
    }
    
    @objc private func doneTapped() {
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
            case .other(let custom): return !custom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        }()
        guard speciesIsValid else {
            let alert = UIAlertController(
                title: String(localized: "species_required_title", defaultValue: "Species required"),
                message: String(localized: "species_required_msg", defaultValue: "Please select the pet’s species."),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        doneButton.isEnabled = false
        
        if let id = editingProfileID {
            // РЕДАКТИРУЕМ существующую запись
            PetProfilesStorage.shared.update(by: id, from: formData) { [weak self] ok in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.doneButton.isEnabled = true
                    if ok {
                        self.closeTapped()
                    } else {
                        let a = UIAlertController(title: "Error",
                                                  message: "Could not update profile. Please try again.",
                                                  preferredStyle: .alert)
                        a.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(a, animated: true)
                    }
                }
            }
        } else {
            // СОЗДАЁМ новую (поток Create)
            PetProfilesStorage.shared.create(from: formData) { [weak self] ok in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.doneButton.isEnabled = true
                    if ok { self.closeTapped() }
                    else {
                        let a = UIAlertController(title: "Error",
                                                  message: "Could not save profile. Please try again.",
                                                  preferredStyle: .alert)
                        a.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(a, animated: true)
                    }
                }
            }
        }
    }
    
    
    // MARK: Small helpers
    private func speciesTitle(_ species: PetSpecies) -> String? {
        switch species {
        case .cat: return String(localized: "cat_title", defaultValue: "Cat")
        case .dog: return String(localized: "dog_title", defaultValue: "Dog")
        case .other(let custom):
            let t = custom.trimmingCharacters(in: .whitespacesAndNewlines)
            return t.isEmpty ? String(localized: "other_title", defaultValue: "Other") : t
        }
    }
    private func formattedAge(since birthDate: Date) -> String {
        let now = Date()
        let comps = Calendar.current.dateComponents([.year, .month], from: birthDate, to: now)
        let y = comps.year ?? 0
        let m = (comps.month ?? 0) % 12
        if y > 0 {
            return m > 0
            ? String(localized: "age_years_months_title", defaultValue: "\(y) years \(m) months old")
            : String(localized: "age_years_title",        defaultValue: "\(y) years old")
        } else {
            return String(localized: "age_months_title",   defaultValue: "\(max(m,0)) months old")
        }
    }

    // Плейсхолдеры — пока без экранов
    @objc private func ownersTapped() {}
    @objc private func nutritionTapped() {}
    @objc private func healthRecordsTapped() {}
    @objc private func notesTapped() {}
    @objc private func photosTapped() {}
}

extension ReviewPetProfileViewController: PetGeneralInfoViewControllerDelegate {
    func petGeneralInfoViewController(_ controller: PetGeneralInfoViewController, didFinishWith data: PetProfileFormData) {
        self.formData = data
        refreshSummary()
        navigationController?.popViewController(animated: true)
    }
}
