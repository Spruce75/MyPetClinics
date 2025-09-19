//
//  CreateNewVaccinationViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 14.9.2025.
//

import UIKit
import PhotosUI

final class CreateNewVaccinationViewController: UIViewController {

    // MARK: - Editing support
    struct EditingPayload {
        let vaccinationId: UUID
        let title: String
        let dateGiven: Date?
        let notes: String?
        let images: [UIImage] // можно передать пустой массив
    }
    
    var onSaved: (() -> Void)?

    // MARK: - Header data
    private let petDisplayName: String
    private let petAvatarImageData: Data?
    private let petAvatarFileName: String?
    private let petId: UUID? // нужен для создания; при редактировании может быть nil

    // Если не nil — экран работает в режиме редактирования
    private let editingPayload: EditingPayload?

    // MARK: - UI: scaffold
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    private let contentStackView = UIStackView()

    // Header
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

    // "Vaccination title" (обязательное)
    private let sectionTitleLabel: Labels = {
        let label = Labels(
            style: .ordinaryText17LabelStyle,
            text: String(localized: "vaccination_title_field_title", defaultValue: "Vaccination title")
        )
        label.textAlignment = .center
        return label
    }()
    private let vaccinationTitleContainerView = Views(style: .view12Style)
    private let vaccinationTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(
            localized: "vaccination_title_placeholder",
            defaultValue: "Enter title"
        )
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        return textField
    }()

    // Card with date & info
    private let cardContainerView = Views(style: .view12Style)
    private let cardVerticalStackView = UIStackView()

    // NEW: Date (required) + Time (optional)
    private let dateGivenHorizontalStackView = UIStackView()
    private let dateGivenDateContainerView = Views(style: .view12Style)
    private let dateGivenTimeContainerView = Views(style: .view12Style)

    private let dateGivenDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "date_placeholder", defaultValue: "Date")
        textField.textAlignment = .center
        return textField
    }()
    private let dateGivenTimeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "time_placeholder", defaultValue: "Time")
        textField.textAlignment = .center
        return textField
    }()

    private let cardSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    private let vaccinationInfoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isOpaque = false
        textView.text = """
        Vaccination info:
        - name of vaccine
        - vaccine manufacturer
        - batch number
        - valid from (date)
        - valid until (date)
        - vetclinic and veterinarian
        """
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    // "next time" + Date
    private let nextTimeHorizontalStackView = UIStackView()
    private let nextTimeTitleContainerView = Views(style: .view12Style)
    private let nextTimeTitleLabel: Labels = {
        let label = Labels(
            style: .ordinaryText17LabelStyle,
            text: String(localized: "next_time_title", defaultValue: "next time")
        )
        label.textAlignment = .center
        return label
    }()
    private let nextTimeDateContainerView = Views(style: .view12Style)
    private let nextTimeDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "date_placeholder", defaultValue: "Date")
        textField.textAlignment = .center
        return textField
    }()

    // Upload image block (мультивыбор)
    private let uploadContainerView = Views(style: .view12Style)
    private let uploadTitleLabel: Labels = {
        let label = Labels(
            style: .ordinaryText13LabelStyle,
            text: String(localized: "upload_image_title", defaultValue: "Upload an image")
        )
        label.textColor = .secondaryLabel
        return label
    }()
    private let uploadPlaceholderStackView = UIStackView()
    private let uploadIconImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "icloud.and.arrow.up"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .label
        return view
    }()
    private let uploadPlaceholderLabel = Labels(style: .ordinaryText13LabelStyle, text: "Browse File")
    private let thumbnailsGridStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 8
        stack.isHidden = true
        return stack
    }()

    // Bottom bar
    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title", defaultValue: "Done")),
        target: self,
        action: #selector(doneTapped)
    )

    // MARK: - Date handling
    private let dateGivenDatePicker = UIDatePicker()
    private let dateGivenTimePicker = UIDatePicker()
    private let nextTimeDatePicker = UIDatePicker()

    private let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    private let timeOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Images
    private var selectedImages: [UIImage] = []

    // MARK: - Inits
    /// Создание новой вакцинации
    init(petDisplayName: String, petAvatarImageData: Data?, petAvatarFileName: String?, petId: UUID?) {
        self.petDisplayName = petDisplayName
        self.petAvatarImageData = petAvatarImageData
        self.petAvatarFileName = petAvatarFileName
        self.petId = petId
        self.editingPayload = nil
        super.init(nibName: nil, bundle: nil)
    }

    /// Редактирование существующей вакцинации
    init(
        petDisplayName: String,
        petAvatarImageData: Data?,
        petAvatarFileName: String?,
        petId: UUID?,
        editingPayload: EditingPayload
    ) {
        self.petDisplayName = petDisplayName
        self.petAvatarImageData = petAvatarImageData
        self.petAvatarFileName = petAvatarFileName
        self.petId = petId // при редактировании не критично; сохраняем для совместимости
        self.editingPayload = editingPayload
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupViewsAndConstraints()
        configureHeader()
        configureDatePickers()
        configureUploadGesture()
        configureTextViewPlaceholderBehavior()
        applyPlaceholderTypography()
        configureTapToDismissEditing()
        vaccinationTitleTextField.delegate = self
        scrollView.keyboardDismissMode = .onDrag

        // Если редактирование — префилл полей
        if let editingPayload {
            prefillFromEditingPayload(editingPayload)
        }
    }

    // MARK: - Setup
    // Один элемент сетки: картинка + кнопка удаления в правом верхнем углу
    private func makeThumbnailItem(image: UIImage, index: Int, side: CGFloat) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = image
        imageView.tag = index
        imageView.isUserInteractionEnabled = true
        
        // Сохраняем старый вариант удаления через long-press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleRemoveImageGesture(_:)))
        imageView.addGestureRecognizer(longPress)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        deleteButton.layer.cornerRadius = 12
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        deleteButton.tag = index
        deleteButton.accessibilityLabel = String(localized: "remove_photo_title", defaultValue: "Remove photo?")
        deleteButton.addTarget(self, action: #selector(handleRemoveImageButton(_:)), for: .touchUpInside)
        
        container.addSubview(imageView)
        container.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: side),
            
            deleteButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        return container
    }
    
    
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeButton
        
        if editingPayload != nil {
            title = String(localized: "edit_title", defaultValue: "Edit")
        }
    }
    
    private func configureTapToDismissEditing() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    private func configureHeader() {
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
    
    private func configureDatePickers() {
        // Date (обязательно)
        dateGivenDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { dateGivenDatePicker.preferredDatePickerStyle = .wheels }
        dateGivenDatePicker.addTarget(self, action: #selector(dateGivenDateChanged), for: .valueChanged)
        dateGivenDateTextField.inputView = dateGivenDatePicker
        dateGivenDateTextField.inputAccessoryView = makeAccessoryToolbar(selector: #selector(doneForDateGivenDate))
        
        // Time (необязательно)
        dateGivenTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) { dateGivenTimePicker.preferredDatePickerStyle = .wheels }
        dateGivenTimePicker.addTarget(self, action: #selector(dateGivenTimeChanged), for: .valueChanged)
        dateGivenTimeTextField.inputView = dateGivenTimePicker
        dateGivenTimeTextField.inputAccessoryView = makeAccessoryToolbar(selector: #selector(doneForDateGivenTime))

        // next time — только будущие даты (не раньше сегодняшнего дня)
        nextTimeDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { nextTimeDatePicker.preferredDatePickerStyle = .wheels }
        let todayStart = Calendar.current.startOfDay(for: Date())
        nextTimeDatePicker.minimumDate = todayStart
        nextTimeDatePicker.addTarget(self, action: #selector(nextTimePickerChanged), for: .valueChanged)
        nextTimeDateTextField.inputView = nextTimeDatePicker
        nextTimeDateTextField.inputAccessoryView = makeAccessoryToolbar(selector: #selector(doneForNextTime))
    }
    
    // Рендер сетки превью (с крестиком удаления)
    private func refreshThumbnailsGrid() {
        let hasImages = !selectedImages.isEmpty
        uploadPlaceholderStackView.isHidden = hasImages
        thumbnailsGridStackView.isHidden = !hasImages
        
        thumbnailsGridStackView.arrangedSubviews.forEach { row in
            thumbnailsGridStackView.removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        guard hasImages else { return }
        
        let itemsPerRow = 3
        let thumbnailSide: CGFloat = 88
        let spacing: CGFloat = 8
        var currentIndex = 0
        
        while currentIndex < selectedImages.count {
            let row = UIStackView()
            row.axis = .horizontal
            row.alignment = .fill
            row.distribution = .fillEqually
            row.spacing = spacing
            
            for column in 0..<itemsPerRow {
                let index = currentIndex + column
                if index < selectedImages.count {
                    let itemView = makeThumbnailItem(image: selectedImages[index], index: index, side: thumbnailSide)
                    row.addArrangedSubview(itemView)
                    itemView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
                } else {
                    let spacer = UIView()
                    spacer.translatesAutoresizingMaskIntoConstraints = false
                    row.addArrangedSubview(spacer)
                    spacer.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
                }
            }
            
            thumbnailsGridStackView.addArrangedSubview(row)
            currentIndex += itemsPerRow
        }
    }
    
    
    private func makeAccessoryToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneItem = UIBarButtonItem(
            title: String(localized: "done_title", defaultValue: "Done"),
            style: .done,
            target: self,
            action: selector
        )
        toolbar.items = [flexible, doneItem]
        return toolbar
    }

    private func applyPlaceholderTypography() {
        let placeholderFont = dateGivenDateTextField.font ?? UIFont.systemFont(ofSize: 17)
        vaccinationInfoTextView.font = placeholderFont
        vaccinationInfoTextView.textColor = .placeholderText
    }

    private func configureUploadGesture() {
        uploadContainerView.isUserInteractionEnabled = true
        uploadPlaceholderStackView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImageTapped))
        uploadContainerView.addGestureRecognizer(tap)
        uploadPlaceholderStackView.addGestureRecognizer(tap)
    }

    private func configureTextViewPlaceholderBehavior() {
        vaccinationInfoTextView.delegate = self
    }

    private func prefillFromEditingPayload(_ payload: EditingPayload) {
        // Title
        vaccinationTitleTextField.text = payload.title

        // Date & time
        if let dateGiven = payload.dateGiven {
            dateGivenDatePicker.date = dateGiven
            dateGivenDateTextField.text = dateOnlyFormatter.string(from: dateGiven)

            let dateComponents = Calendar.current.dateComponents(in: .current, from: dateGiven)
            let hasExplicitTime =
                (dateComponents.hour ?? 0) != 0 ||
                (dateComponents.minute ?? 0) != 0 ||
                (dateComponents.second ?? 0) != 0

            if hasExplicitTime {
                dateGivenTimePicker.date = dateGiven
                dateGivenTimeTextField.text = timeOnlyFormatter.string(from: dateGiven)
            } else {
                dateGivenTimeTextField.text = nil
            }
        } else {
            dateGivenDateTextField.text = nil
            dateGivenTimeTextField.text = nil
        }

        // Notes
        if let notes = payload.notes?.nilIfBlank, !notes.isEmpty {
            vaccinationInfoTextView.text = notes
            vaccinationInfoTextView.textColor = .label
        } else {
            vaccinationInfoTextView.text = """
            Vaccination info:
            - name of vaccine
            - vaccine manufacturer
            - batch number
            - valid from (date)
            - valid until (date)
            - vetclinic and veterinarian
            """
            applyPlaceholderTypography()
        }

        // Images
        selectedImages = payload.images
        refreshThumbnailsGrid()
    }

    // MARK: - Actions
    @objc private func handleRemoveImageButton(_ sender: UIButton) {
        let index = sender.tag
        guard index < selectedImages.count else { return }
        
        let alertController = UIAlertController(
            title: String(localized: "remove_photo_title", defaultValue: "Remove photo?"),
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(
            title: String(localized: "remove_title", defaultValue: "Remove"),
            style: .destructive,
            handler: { [weak self] _ in
                self?.selectedImages.remove(at: index)
                self?.refreshThumbnailsGrid()
            })
        )
        alertController.addAction(UIAlertAction(
            title: String(localized: "cancel_title", defaultValue: "Cancel"),
            style: .cancel
        ))
        present(alertController, animated: true)
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

    @objc private func handleTapToDismiss() { view.endEditing(true) }

    @objc private func doneTapped() {
        // 1) Валидация заголовка
        let titleText = (vaccinationTitleTextField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !titleText.isEmpty else { return /* показать алерт при желании */ }

        // 2) Валидация даты (обязательна)
        let isDateEmpty = (dateGivenDateTextField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        guard !isDateEmpty else {
            let alert = UIAlertController(
                title: String(localized: "validation_title", defaultValue: "Missing date"),
                message: String(localized: "validation_msg_date", defaultValue: "Please select a date for the vaccination."),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // 3) Собираем dateGiven из выбранных контролов
        var components = Calendar.current.dateComponents([.year, .month, .day], from: dateGivenDatePicker.date)
        let timeEntered = !(dateGivenTimeTextField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if timeEntered {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: dateGivenTimePicker.date)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
        } else {
            components.hour = 0
            components.minute = 0
        }
        let composedDateGiven = Calendar.current.date(from: components)

        // 4) Заметки
        let notes: String?
        if vaccinationInfoTextView.textColor == .placeholderText {
            notes = nil
        } else {
            let raw = vaccinationInfoTextView.text ?? ""
            notes = raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : raw
        }

        // 5) Сохранение/обновление
        if let editingPayload {
            // Режим редактирования
            _ = VaccinationsStorage.shared.updateVaccination(
                id: editingPayload.vaccinationId,
                title: titleText,
                dateGiven: composedDateGiven,
                notes: notes,
                images: selectedImages
            )
        } else {
            // Режим создания — нужен petId
            guard let petId = petId else {
                let alert = UIAlertController(
                    title: "Cannot save",
                    message: "Missing pet identifier. Please open this screen from the pet profile.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                assertionFailure("petId is nil — нужно передать PetProfileCoreData.id при создании CreateNewVaccinationViewController")
                return
            }

            VaccinationsStorage.shared.createVaccination(
                forPetId: petId,
                title: titleText,
                dateGiven: composedDateGiven,
                notes: notes,
                images: selectedImages
            )
        }

        onSaved?()
        // 6) Назад
        navigationController?.popViewController(animated: true)
    }

    @objc private func dateGivenDateChanged() {
        dateGivenDateTextField.text = dateOnlyFormatter.string(from: dateGivenDatePicker.date)
    }

    @objc private func dateGivenTimeChanged() {
        dateGivenTimeTextField.text = timeOnlyFormatter.string(from: dateGivenTimePicker.date)
    }

    @objc private func doneForDateGivenDate() { dateGivenDateTextField.resignFirstResponder() }
    @objc private func doneForDateGivenTime() { dateGivenTimeTextField.resignFirstResponder() }

    @objc private func nextTimePickerChanged() {
        if let minimum = nextTimeDatePicker.minimumDate, nextTimeDatePicker.date < minimum {
            nextTimeDatePicker.date = minimum
        }
        nextTimeDateTextField.text = dateOnlyFormatter.string(from: nextTimeDatePicker.date)
    }
    @objc private func doneForNextTime() { nextTimeDateTextField.resignFirstResponder() }

    @objc private func pickImageTapped() {
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = 0 // multi-select
            let picker = PHPickerViewController(configuration: configuration)
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

    // Рендер сетки превью
//    private func refreshThumbnailsGrid() {
//        let hasImages = !selectedImages.isEmpty
//        uploadPlaceholderStackView.isHidden = hasImages
//        thumbnailsGridStackView.isHidden = !hasImages
//
//        thumbnailsGridStackView.arrangedSubviews.forEach { row in
//            thumbnailsGridStackView.removeArrangedSubview(row); row.removeFromSuperview()
//        }
//        guard hasImages else { return }
//
//        let itemsPerRow = 3
//        let thumbnailSide: CGFloat = 88
//        let spacing: CGFloat = 8
//        var currentIndex = 0
//
//        while currentIndex < selectedImages.count {
//            let row = UIStackView()
//            row.axis = .horizontal
//            row.alignment = .fill
//            row.distribution = .fillEqually
//            row.spacing = spacing
//
//            for column in 0..<itemsPerRow {
//                if currentIndex + column < selectedImages.count {
//                    let imageView = UIImageView()
//                    imageView.translatesAutoresizingMaskIntoConstraints = false
//                    imageView.contentMode = .scaleAspectFill
//                    imageView.clipsToBounds = true
//                    imageView.layer.cornerRadius = 12
//                    imageView.image = selectedImages[currentIndex + column]
//                    imageView.tag = currentIndex + column
//                    let longPress = UILongPressGestureRecognizer(
//                        target: self,
//                        action: #selector(handleRemoveImageGesture(_:))
//                    )
//                    imageView.addGestureRecognizer(longPress)
//                    imageView.isUserInteractionEnabled = true
//
//                    row.addArrangedSubview(imageView)
//                    imageView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                } else {
//                    let spacer = UIView()
//                    spacer.translatesAutoresizingMaskIntoConstraints = false
//                    row.addArrangedSubview(spacer)
//                    spacer.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                }
//            }
//
//            thumbnailsGridStackView.addArrangedSubview(row)
//            currentIndex += itemsPerRow
//        }
//    }

    @objc private func handleRemoveImageGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let view = gesture.view else { return }
        let index = view.tag
        guard index < selectedImages.count else { return }
        let alertController = UIAlertController(
            title: String(localized: "remove_photo_title", defaultValue: "Remove photo?"),
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(
            title: String(localized: "remove_title", defaultValue: "Remove"),
            style: .destructive,
            handler: { [weak self] _ in
                self?.selectedImages.remove(at: index)
                self?.refreshThumbnailsGrid()
            })
        )
        alertController.addAction(UIAlertAction(
            title: String(localized: "cancel_title", defaultValue: "Cancel"),
            style: .cancel
        ))
        present(alertController, animated: true)
    }
}

// MARK: - Layout
private extension CreateNewVaccinationViewController {
    func setupViewsAndConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        view.addSubview(bottomBarContainerView)
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

        // Vaccination title field
        vaccinationTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        vaccinationTitleContainerView.backgroundColor = .secondarySystemBackground
        vaccinationTitleContainerView.addSubview(vaccinationTitleTextField)

        // Card
        cardContainerView.backgroundColor = .secondarySystemBackground
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        cardVerticalStackView.axis = .vertical
        cardVerticalStackView.alignment = .fill
        cardVerticalStackView.spacing = 12
        cardContainerView.addSubview(cardVerticalStackView)

        // NEW: Date + Time row
        dateGivenHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        dateGivenHorizontalStackView.axis = .horizontal
        dateGivenHorizontalStackView.spacing = 16
        dateGivenHorizontalStackView.distribution = .fillEqually

        dateGivenDateContainerView.backgroundColor = .secondarySystemBackground
        dateGivenTimeContainerView.backgroundColor = .secondarySystemBackground

        dateGivenDateContainerView.addSubview(dateGivenDateTextField)
        dateGivenTimeContainerView.addSubview(dateGivenTimeTextField)

        // Next time row
        nextTimeHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        nextTimeHorizontalStackView.axis = .horizontal
        nextTimeHorizontalStackView.spacing = 16
        nextTimeHorizontalStackView.distribution = .fillEqually

        nextTimeTitleContainerView.backgroundColor = .secondarySystemBackground
        nextTimeDateContainerView.backgroundColor = .secondarySystemBackground

        nextTimeTitleContainerView.addSubview(nextTimeTitleLabel)
        nextTimeDateContainerView.addSubview(nextTimeDateTextField)

        // Upload area
        uploadContainerView.backgroundColor = .secondarySystemBackground
        uploadContainerView.translatesAutoresizingMaskIntoConstraints = false
        uploadTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        uploadPlaceholderStackView.translatesAutoresizingMaskIntoConstraints = false
        uploadPlaceholderStackView.axis = .vertical
        uploadPlaceholderStackView.alignment = .center
        uploadPlaceholderStackView.spacing = 8
        uploadPlaceholderStackView.addArrangedSubview(uploadIconImageView)
        uploadPlaceholderStackView.addArrangedSubview(uploadPlaceholderLabel)

        uploadContainerView.addSubview(uploadTitleLabel)
        uploadContainerView.addSubview(uploadPlaceholderStackView)
        uploadContainerView.addSubview(thumbnailsGridStackView)

        // Assemble
        contentStackView.addArrangedSubview(headerContainerView)
        contentStackView.addArrangedSubview(sectionTitleLabel)
        contentStackView.addArrangedSubview(vaccinationTitleContainerView)
        contentStackView.addArrangedSubview(cardContainerView)
        contentStackView.addArrangedSubview(nextTimeHorizontalStackView)
        contentStackView.addArrangedSubview(uploadContainerView)

        // Bottom bar
        let readable = bottomBarContainerView.readableContentGuide
        bottomBarContainerView.addSubview(doneButton)

        NSLayoutConstraint.activate([
            // Scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarContainerView.topAnchor),

            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16),

            // Header
            headerHorizontalStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerHorizontalStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            headerHorizontalStackView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            headerHorizontalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainerView.leadingAnchor),
            headerHorizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),

            // Vaccination title
            vaccinationTitleTextField.leadingAnchor.constraint(equalTo: vaccinationTitleContainerView.leadingAnchor, constant: 12),
            vaccinationTitleTextField.trailingAnchor.constraint(equalTo: vaccinationTitleContainerView.trailingAnchor, constant: -12),
            vaccinationTitleTextField.topAnchor.constraint(equalTo: vaccinationTitleContainerView.topAnchor, constant: 10),
            vaccinationTitleTextField.bottomAnchor.constraint(equalTo: vaccinationTitleContainerView.bottomAnchor, constant: -10),
            vaccinationTitleTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

            // Card inner
            cardVerticalStackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            cardVerticalStackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            cardVerticalStackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            cardVerticalStackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),

            // Date & Time row inside card
            dateGivenDateTextField.centerXAnchor.constraint(equalTo: dateGivenDateContainerView.centerXAnchor),
            dateGivenDateTextField.centerYAnchor.constraint(equalTo: dateGivenDateContainerView.centerYAnchor),
            dateGivenTimeTextField.centerXAnchor.constraint(equalTo: dateGivenTimeContainerView.centerXAnchor),
            dateGivenTimeTextField.centerYAnchor.constraint(equalTo: dateGivenTimeContainerView.centerYAnchor),
            dateGivenDateContainerView.heightAnchor.constraint(equalToConstant: 44),
            dateGivenTimeContainerView.heightAnchor.constraint(equalToConstant: 44),

            cardSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            // Next time row
            nextTimeTitleLabel.centerXAnchor.constraint(equalTo: nextTimeTitleContainerView.centerXAnchor),
            nextTimeTitleLabel.centerYAnchor.constraint(equalTo: nextTimeTitleContainerView.centerYAnchor),
            nextTimeDateTextField.centerXAnchor.constraint(equalTo: nextTimeDateContainerView.centerXAnchor),
            nextTimeDateTextField.centerYAnchor.constraint(equalTo: nextTimeDateContainerView.centerYAnchor),
            nextTimeTitleContainerView.heightAnchor.constraint(equalToConstant: 44),
            nextTimeDateContainerView.heightAnchor.constraint(equalToConstant: 44),

            // Upload
            uploadTitleLabel.topAnchor.constraint(equalTo: uploadContainerView.topAnchor, constant: 12),
            uploadTitleLabel.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor, constant: 12),
            uploadTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: uploadContainerView.trailingAnchor, constant: -12),

            uploadPlaceholderStackView.centerXAnchor.constraint(equalTo: uploadContainerView.centerXAnchor),
            uploadPlaceholderStackView.centerYAnchor.constraint(equalTo: uploadContainerView.centerYAnchor),
            uploadIconImageView.widthAnchor.constraint(equalToConstant: 36),
            uploadIconImageView.heightAnchor.constraint(equalToConstant: 36),

            thumbnailsGridStackView.topAnchor.constraint(equalTo: uploadTitleLabel.bottomAnchor, constant: 12),
            thumbnailsGridStackView.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor, constant: 12),
            thumbnailsGridStackView.trailingAnchor.constraint(equalTo: uploadContainerView.trailingAnchor, constant: -12),
            thumbnailsGridStackView.bottomAnchor.constraint(equalTo: uploadContainerView.bottomAnchor, constant: -12),

            uploadContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220),

            // Bottom bar
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

        // Build card
        dateGivenHorizontalStackView.addArrangedSubview(dateGivenDateContainerView)
        dateGivenHorizontalStackView.addArrangedSubview(dateGivenTimeContainerView)

        cardVerticalStackView.addArrangedSubview(dateGivenHorizontalStackView)
        cardVerticalStackView.addArrangedSubview(cardSeparatorView)
        cardVerticalStackView.addArrangedSubview(vaccinationInfoTextView)

        // Build next-time row
        nextTimeHorizontalStackView.addArrangedSubview(nextTimeTitleContainerView)
        nextTimeHorizontalStackView.addArrangedSubview(nextTimeDateContainerView)
    }
}

// MARK: - Delegates
extension CreateNewVaccinationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = """
            Vaccination info:
            - name of vaccine
            - vaccine manufacturer
            - batch number
            - valid from (date)
            - valid until (date)
            - vetclinic and veterinarian
            """
            applyPlaceholderTypography()
        }
    }
}

extension CreateNewVaccinationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === vaccinationTitleTextField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

@available(iOS 14, *)
extension CreateNewVaccinationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard !results.isEmpty else { return }

        let dispatchGroup = DispatchGroup()
        var newImages: [UIImage] = []

        for result in results {
            let provider = result.itemProvider
            guard provider.canLoadObject(ofClass: UIImage.self) else { continue }
            dispatchGroup.enter()
            provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                defer { dispatchGroup.leave() }
                guard let _ = self, let image = object as? UIImage else { return }
                newImages.append(image.resizedToFit(maxDimension: 1600))
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.selectedImages.append(contentsOf: newImages)
            self.refreshThumbnailsGrid()
        }
    }
}

extension CreateNewVaccinationViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss(animated: true) }
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        dismiss(animated: true)
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            selectedImages.append(image.resizedToFit(maxDimension: 1600))
            refreshThumbnailsGrid()
        }
    }
}
