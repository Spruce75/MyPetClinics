//
//  VaccinationDetailsViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 18.9.2025.
//

//import UIKit
//
//final class VaccinationDetailsViewController: UIViewController {
//
//    // MARK: - Header context
//    private let petDisplayName: String
//    private let petAvatarImageData: Data?
//    private let petAvatarFileName: String?
//    private let vaccinationId: UUID
//
//    // MARK: - UI
//    private let scrollView = UIScrollView()
//    private let contentContainerView = UIView()
//    private let contentStackView = UIStackView()
//
//    private let headerContainerView = UIView()
//    private let headerHorizontalStackView = UIStackView()
//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    private let petNameLabel = Labels(style: .bold34TitleLabelStyle)
//
//    private let sectionTitleLabel: Labels = {
//        let label = Labels(
//            style: .ordinaryText17LabelStyle,
//            text: String(localized: "vaccinations_title", defaultValue: "Vaccinations")
//        )
//        label.textAlignment = .center
//        return label
//    }()
//
//    // Title row (read-only)
//    private let vaccinationTitleContainerView = Views(style: .view12Style)
//    private let vaccinationTitleLabel: Labels = {
//        let label = Labels(style: .ordinaryText17LabelStyle)
//        label.numberOfLines = 0
//        return label
//    }()
//
//    // Card with date & notes (read-only)
//    private let cardContainerView = Views(style: .view12Style)
//    private let cardVerticalStackView = UIStackView()
//    private let dateAndTimeLabel: Labels = {
//        let label = Labels(style: .ordinaryText17LabelStyle)
//        label.numberOfLines = 1
//        return label
//    }()
//    private let cardSeparatorView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .separator
//        return view
//    }()
//    private let notesLabel: Labels = {
//        let label = Labels(style: .ordinaryText17LabelStyle)
//        label.numberOfLines = 0
//        return label
//    }()
//
//    // Images grid (read-only)
//    private let imagesContainerView = Views(style: .view12Style)
//    private let imagesGridStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.spacing = 8
//        return stackView
//    }()
//
//    // MARK: - State
//    private var vaccinationDetails: VaccinationDetails?
//
//    private let dateTimeFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = .current
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter
//    }()
//
//    private let dateOnlyFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = .current
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter
//    }()
//
//    // MARK: - Init
//    init(
//        petDisplayName: String,
//        petAvatarImageData: Data?,
//        petAvatarFileName: String?,
//        vaccinationId: UUID
//    ) {
//        self.petDisplayName = petDisplayName
//        self.petAvatarImageData = petAvatarImageData
//        self.petAvatarFileName = petAvatarFileName
//        self.vaccinationId = vaccinationId
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupNavigation()
//        setupViewsAndConstraints()
//        fillHeader()
//        loadDetails()
//    }
//
//    private func setupNavigation() {
//        // Close
//        let closeBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "xmark"),
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//        closeBarButtonItem.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
//        navigationItem.rightBarButtonItem = closeBarButtonItem
//
//        // Edit
//        let editBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "square.and.pencil"),
//            style: .plain,
//            target: self,
//            action: #selector(editTapped)
//        )
//        editBarButtonItem.accessibilityLabel = String(localized: "edit_title", defaultValue: "Edit")
//        navigationItem.leftBarButtonItem = editBarButtonItem
//    }
//
//    // MARK: - Build UI
//    private func setupViewsAndConstraints() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
//        contentStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentContainerView)
//        contentContainerView.addSubview(contentStackView)
//
//        contentStackView.axis = .vertical
//        contentStackView.alignment = .fill
//        contentStackView.spacing = 16
//
//        // Header
//        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
//        headerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        headerHorizontalStackView.axis = .horizontal
//        headerHorizontalStackView.alignment = .center
//        headerHorizontalStackView.spacing = 16
//        headerContainerView.addSubview(headerHorizontalStackView)
//
//        let avatarSide: CGFloat = 80
//        avatarImageView.layer.cornerRadius = avatarSide / 2
//
//        headerHorizontalStackView.addArrangedSubview(avatarImageView)
//        headerHorizontalStackView.addArrangedSubview(petNameLabel)
//        petNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//
//        // Title container
//        vaccinationTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
//        vaccinationTitleContainerView.backgroundColor = .secondarySystemBackground
//        vaccinationTitleContainerView.addSubview(vaccinationTitleLabel)
//        vaccinationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        // Card
//        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
//        cardContainerView.backgroundColor = .secondarySystemBackground
//
//        cardVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        cardVerticalStackView.axis = .vertical
//        cardVerticalStackView.alignment = .fill
//        cardVerticalStackView.spacing = 12
//        cardContainerView.addSubview(cardVerticalStackView)
//
//        // Images
//        imagesContainerView.translatesAutoresizingMaskIntoConstraints = false
//        imagesContainerView.backgroundColor = .secondarySystemBackground
//        imagesContainerView.isHidden = true
//        imagesContainerView.addSubview(imagesGridStackView)
//
//        // Add to main stack
//        contentStackView.addArrangedSubview(headerContainerView)
//        contentStackView.addArrangedSubview(sectionTitleLabel)
//        contentStackView.addArrangedSubview(vaccinationTitleContainerView)
//        contentStackView.addArrangedSubview(cardContainerView)
//        contentStackView.addArrangedSubview(imagesContainerView)
//
//        NSLayoutConstraint.activate([
//            // scroll
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
//            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
//            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//
//            contentStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
//            contentStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
//            contentStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
//            contentStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16),
//
//            // header
//            headerHorizontalStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
//            headerHorizontalStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
//            headerHorizontalStackView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
//            headerHorizontalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainerView.leadingAnchor),
//            headerHorizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),
//            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
//            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),
//
//            // title
//            vaccinationTitleLabel.topAnchor.constraint(equalTo: vaccinationTitleContainerView.topAnchor, constant: 10),
//            vaccinationTitleLabel.bottomAnchor.constraint(equalTo: vaccinationTitleContainerView.bottomAnchor, constant: -10),
//            vaccinationTitleLabel.leadingAnchor.constraint(equalTo: vaccinationTitleContainerView.leadingAnchor, constant: 12),
//            vaccinationTitleLabel.trailingAnchor.constraint(equalTo: vaccinationTitleContainerView.trailingAnchor, constant: -12),
//
//            // card
//            cardVerticalStackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
//            cardVerticalStackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
//            cardVerticalStackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
//            cardVerticalStackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),
//            cardSeparatorView.heightAnchor.constraint(equalToConstant: 1),
//
//            // images
//            imagesGridStackView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor, constant: 12),
//            imagesGridStackView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor, constant: 12),
//            imagesGridStackView.trailingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: -12),
//            imagesGridStackView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: -12),
//        ])
//
//        // compose card
//        cardVerticalStackView.addArrangedSubview(dateAndTimeLabel)
//        cardVerticalStackView.addArrangedSubview(cardSeparatorView)
//        cardVerticalStackView.addArrangedSubview(notesLabel)
//    }
//
//    private func fillHeader() {
//        petNameLabel.text = petDisplayName.nilIfBlank
//            ?? String(localized: "name_title", defaultValue: "Name")
//        if let avatarImageData = petAvatarImageData, let image = UIImage(data: avatarImageData) {
//            avatarImageView.image = image
//        } else if let fileName = petAvatarFileName {
//            avatarImageView.image = UIImage.loadOrPlaceholder(named: fileName, in: traitCollection)
//        } else {
//            avatarImageView.image = UIImage(named: "no photo")
//        }
//    }
//
//    private func loadDetails() {
//        guard let details = VaccinationsStorage.shared.fetchVaccination(by: vaccinationId) else {
//            let alertController = UIAlertController(
//                title: String(localized: "error_title", defaultValue: "Error"),
//                message: String(localized: "not_found_title", defaultValue: "Vaccination not found."),
//                preferredStyle: .alert
//            )
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
//                self?.navigationController?.popViewController(animated: true)
//            }))
//            present(alertController, animated: true)
//            return
//        }
//        vaccinationDetails = details
//
//        vaccinationTitleLabel.text = details.title
//
//        if let dateGiven = details.dateGiven {
//            let dateComponents = Calendar.current.dateComponents(in: .current, from: dateGiven)
//            let hasExplicitTime =
//                (dateComponents.hour ?? 0) != 0 ||
//                (dateComponents.minute ?? 0) != 0 ||
//                (dateComponents.second ?? 0) != 0
//
//            dateAndTimeLabel.text = hasExplicitTime
//                ? dateTimeFormatter.string(from: dateGiven)
//                : dateOnlyFormatter.string(from: dateGiven)
//        } else {
//            dateAndTimeLabel.text = ""
//        }
//
//        if let notes = details.notes?.nilIfBlank {
//            notesLabel.text = notes
//            notesLabel.textColor = .label
//        } else {
//            notesLabel.text = String(localized: "no_notes_title", defaultValue: "No notes")
//            notesLabel.textColor = .secondaryLabel
//        }
//
//        if let imageData = details.imageData, let image = UIImage(data: imageData) {
//            renderImages([image])
//        } else {
//            imagesContainerView.isHidden = true
//        }
//    }
//
//    private func renderImages(_ images: [UIImage]) {
//        imagesGridStackView.arrangedSubviews.forEach { subview in
//            imagesGridStackView.removeArrangedSubview(subview)
//            subview.removeFromSuperview()
//        }
//        guard !images.isEmpty else {
//            imagesContainerView.isHidden = true
//            return
//        }
//        imagesContainerView.isHidden = false
//
//        let itemsPerRow = 3
//        let thumbnailSide: CGFloat = 88
//        let spacing: CGFloat = 8
//        var currentIndex = 0
//
//        while currentIndex < images.count {
//            let rowStackView = UIStackView()
//            rowStackView.axis = .horizontal
//            rowStackView.alignment = .fill
//            rowStackView.distribution = .fillEqually
//            rowStackView.spacing = spacing
//
//            for column in 0..<itemsPerRow {
//                if currentIndex + column < images.count {
//                    let imageView = UIImageView()
//                    imageView.translatesAutoresizingMaskIntoConstraints = false
//                    imageView.contentMode = .scaleAspectFill
//                    imageView.clipsToBounds = true
//                    imageView.layer.cornerRadius = 12
//                    imageView.image = images[currentIndex + column]
//                    rowStackView.addArrangedSubview(imageView)
//                    imageView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                } else {
//                    let spacerView = UIView()
//                    spacerView.translatesAutoresizingMaskIntoConstraints = false
//                    rowStackView.addArrangedSubview(spacerView)
//                    spacerView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                }
//            }
//
//            imagesGridStackView.addArrangedSubview(rowStackView)
//            currentIndex += itemsPerRow
//        }
//    }
//
//    // MARK: - Actions
//    @objc private func closeTapped() {
//        if let navigationController = navigationController, navigationController.presentingViewController != nil {
//            navigationController.dismiss(animated: true)
//        } else if presentingViewController != nil {
//            dismiss(animated: true)
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//
//    @objc private func editTapped() {
//        // Берём актуальные данные из стора (на случай, если поменялись)
//        guard let details = VaccinationsStorage.shared.fetchVaccination(by: vaccinationId) else { return }
//
//        var images: [UIImage] = []
//        if let imageData = details.imageData, let image = UIImage(data: imageData) {
//            images = [image]
//        }
//
//        let payload = CreateNewVaccinationViewController.EditingPayload(
//            vaccinationId: vaccinationId,
//            title: details.title ?? "",
//            dateGiven: details.dateGiven,
//            notes: details.notes,
//            images: images
//        )
//
//        let editor = CreateNewVaccinationViewController(
//            petDisplayName: petDisplayName,
//            petAvatarImageData: petAvatarImageData,
//            petAvatarFileName: petAvatarFileName,
//            petId: nil, // при редактировании не нужен
//            editingPayload: payload
//        )
//        navigationController?.pushViewController(editor, animated: true)
//    }
//}

import UIKit

final class VaccinationDetailsViewController: UIViewController {

    // MARK: - Header context
    private let petDisplayName: String
    private let petAvatarImageData: Data?
    private let petAvatarFileName: String?
    private let vaccinationId: UUID

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    private let contentStackView = UIStackView()

    private let headerContainerView = UIView()
    private let headerHorizontalStackView = UIStackView()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let petNameLabel = Labels(style: .bold34TitleLabelStyle)

    private let sectionTitleLabel: Labels = {
        let label = Labels(
            style: .ordinaryText17LabelStyle,
            text: String(localized: "vaccinations_title", defaultValue: "Vaccinations")
        )
        label.textAlignment = .center
        return label
    }()

    // Title row (read-only)
    private let vaccinationTitleContainerView = Views(style: .view12Style)
    private let vaccinationTitleLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        label.numberOfLines = 0
        return label
    }()

    // Card with date & notes (read-only)
    private let cardContainerView = Views(style: .view12Style)
    private let cardVerticalStackView = UIStackView()
    private let dateAndTimeLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        label.numberOfLines = 1
        return label
    }()
    private let cardSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    private let notesLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        label.numberOfLines = 0
        return label
    }()

    // Images grid (read-only)
    private let imagesContainerView = Views(style: .view12Style)
    private let imagesGridStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - State
    private var vaccinationDetails: VaccinationDetails?

    private let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - Init
    init(
        petDisplayName: String,
        petAvatarImageData: Data?,
        petAvatarFileName: String?,
        vaccinationId: UUID
    ) {
        self.petDisplayName = petDisplayName
        self.petAvatarImageData = petAvatarImageData
        self.petAvatarFileName = petAvatarFileName
        self.vaccinationId = vaccinationId
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
        loadDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Возвращаемся из редактора — подтягиваем актуальные данные
        loadDetails()
    }

    private func setupNavigation() {
        // Close
        let closeBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeBarButtonItem.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeBarButtonItem

        // Edit
        let editBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        editBarButtonItem.accessibilityLabel = String(localized: "edit_title", defaultValue: "Edit")
        navigationItem.leftBarButtonItem = editBarButtonItem
    }

    // MARK: - Build UI
    private func setupViewsAndConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        contentContainerView.addSubview(contentStackView)

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 16

        // Header
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        headerHorizontalStackView.axis = .horizontal
        headerHorizontalStackView.alignment = .center
        headerHorizontalStackView.spacing = 16
        headerContainerView.addSubview(headerHorizontalStackView)

        let avatarSide: CGFloat = 80
        avatarImageView.layer.cornerRadius = avatarSide / 2

        headerHorizontalStackView.addArrangedSubview(avatarImageView)
        headerHorizontalStackView.addArrangedSubview(petNameLabel)
        petNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Title container
        vaccinationTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        vaccinationTitleContainerView.backgroundColor = .secondarySystemBackground
        vaccinationTitleContainerView.addSubview(vaccinationTitleLabel)
        vaccinationTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Card
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.backgroundColor = .secondarySystemBackground

        cardVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        cardVerticalStackView.axis = .vertical
        cardVerticalStackView.alignment = .fill
        cardVerticalStackView.spacing = 12
        cardContainerView.addSubview(cardVerticalStackView)

        // Images
        imagesContainerView.translatesAutoresizingMaskIntoConstraints = false
        imagesContainerView.backgroundColor = .secondarySystemBackground
        imagesContainerView.isHidden = true
        imagesContainerView.addSubview(imagesGridStackView)

        // Add to main stack
        contentStackView.addArrangedSubview(headerContainerView)
        contentStackView.addArrangedSubview(sectionTitleLabel)
        contentStackView.addArrangedSubview(vaccinationTitleContainerView)
        contentStackView.addArrangedSubview(cardContainerView)
        contentStackView.addArrangedSubview(imagesContainerView)

        NSLayoutConstraint.activate([
            // scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16),

            // header
            headerHorizontalStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerHorizontalStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            headerHorizontalStackView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            headerHorizontalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainerView.leadingAnchor),
            headerHorizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),

            // title
            vaccinationTitleLabel.topAnchor.constraint(equalTo: vaccinationTitleContainerView.topAnchor, constant: 10),
            vaccinationTitleLabel.bottomAnchor.constraint(equalTo: vaccinationTitleContainerView.bottomAnchor, constant: -10),
            vaccinationTitleLabel.leadingAnchor.constraint(equalTo: vaccinationTitleContainerView.leadingAnchor, constant: 12),
            vaccinationTitleLabel.trailingAnchor.constraint(equalTo: vaccinationTitleContainerView.trailingAnchor, constant: -12),

            // card
            cardVerticalStackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            cardVerticalStackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            cardVerticalStackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            cardVerticalStackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),
            cardSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            // images
            imagesGridStackView.topAnchor.constraint(equalTo: imagesContainerView.topAnchor, constant: 12),
            imagesGridStackView.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor, constant: 12),
            imagesGridStackView.trailingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor, constant: -12),
            imagesGridStackView.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor, constant: -12),
        ])

        // compose card
        cardVerticalStackView.addArrangedSubview(dateAndTimeLabel)
        cardVerticalStackView.addArrangedSubview(cardSeparatorView)
        cardVerticalStackView.addArrangedSubview(notesLabel)
    }

    private func fillHeader() {
        petNameLabel.text = petDisplayName.nilIfBlank
            ?? String(localized: "name_title", defaultValue: "Name")
        if let avatarImageData = petAvatarImageData, let image = UIImage(data: avatarImageData) {
            avatarImageView.image = image
        } else if let fileName = petAvatarFileName {
            avatarImageView.image = UIImage.loadOrPlaceholder(named: fileName, in: traitCollection)
        } else {
            avatarImageView.image = UIImage(named: "no photo")
        }
    }

    private func loadDetails() {
        guard let details = VaccinationsStorage.shared.fetchVaccination(by: vaccinationId) else {
            let alertController = UIAlertController(
                title: String(localized: "error_title", defaultValue: "Error"),
                message: String(localized: "not_found_title", defaultValue: "Vaccination not found."),
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            present(alertController, animated: true)
            return
        }
        vaccinationDetails = details

        vaccinationTitleLabel.text = details.title

        if let dateGiven = details.dateGiven {
            let dateComponents = Calendar.current.dateComponents(in: .current, from: dateGiven)
            let hasExplicitTime =
                (dateComponents.hour ?? 0) != 0 ||
                (dateComponents.minute ?? 0) != 0 ||
                (dateComponents.second ?? 0) != 0

            dateAndTimeLabel.text = hasExplicitTime
                ? dateTimeFormatter.string(from: dateGiven)
                : dateOnlyFormatter.string(from: dateGiven)
        } else {
            dateAndTimeLabel.text = ""
        }

        if let notes = details.notes?.nilIfBlank {
            notesLabel.text = notes
            notesLabel.textColor = .label
        } else {
            notesLabel.text = String(localized: "no_notes_title", defaultValue: "No notes")
            notesLabel.textColor = .secondaryLabel
        }

        if let imageData = details.imageData, let image = UIImage(data: imageData) {
            renderImages([image])
        } else {
            imagesContainerView.isHidden = true
            // очистим грид на случай, если фото удалили при редактировании
            imagesGridStackView.arrangedSubviews.forEach { v in
                imagesGridStackView.removeArrangedSubview(v)
                v.removeFromSuperview()
            }
        }
        if let details = vaccinationDetails {
            let images = details.uiImages
            if images.isEmpty {
                imagesContainerView.isHidden = true
            } else {
                renderImages(images)
            }
        }
    }

    private func renderImages(_ images: [UIImage]) {
        imagesGridStackView.arrangedSubviews.forEach { subview in
            imagesGridStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        guard !images.isEmpty else {
            imagesContainerView.isHidden = true
            return
        }
        imagesContainerView.isHidden = false

        let itemsPerRow = 3
        let thumbnailSide: CGFloat = 88
        let spacing: CGFloat = 8
        var currentIndex = 0

        while currentIndex < images.count {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = spacing

            for column in 0..<itemsPerRow {
                if currentIndex + column < images.count {
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.layer.cornerRadius = 12
                    imageView.image = images[currentIndex + column]
                    rowStackView.addArrangedSubview(imageView)
                    imageView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
                } else {
                    let spacerView = UIView()
                    spacerView.translatesAutoresizingMaskIntoConstraints = false
                    rowStackView.addArrangedSubview(spacerView)
                    spacerView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
                }
            }

            imagesGridStackView.addArrangedSubview(rowStackView)
            currentIndex += itemsPerRow
        }
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        if let navigationController = navigationController, navigationController.presentingViewController != nil {
            navigationController.dismiss(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func editTapped() {
        guard let details = VaccinationsStorage.shared.fetchVaccination(by: vaccinationId) else { return }
        
        let payload = CreateNewVaccinationViewController.EditingPayload(
            vaccinationId: vaccinationId,
            title: details.title,
            dateGiven: details.dateGiven,
            notes: details.notes,
            images: details.uiImages
        )
        
        let editor = CreateNewVaccinationViewController(
            petDisplayName: petDisplayName,
            petAvatarImageData: petAvatarImageData,
            petAvatarFileName: petAvatarFileName,
            petId: nil,
            editingPayload: payload
        )
        
        editor.onSaved = { [weak self] in
            self?.loadDetails()     // перезагружаем данные сразу после сохранения
        }
        
        navigationController?.pushViewController(editor, animated: true)
    }
    
}
