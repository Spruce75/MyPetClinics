//
//  CreateNewVaccinationViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 14.9.2025.
//

//import UIKit
//import PhotosUI
//
//final class CreateNewVaccinationViewController: UIViewController {
//
//    // MARK: - Header data
//    private let petDisplayName: String
//    private let petAvatarImageData: Data?
//    private let petAvatarFileName: String?
//
//    // MARK: - UI: scaffold
//    private let scrollView = UIScrollView()
//    private let contentContainerView = UIView()
//    private let contentStackView = UIStackView()
//
//    // Header
//    private let headerContainerView = UIView()
//    private let headerHorizontalStackView = UIStackView()
//    private let avatarImageView: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        return view
//    }()
//    private let petNameLabel = Labels(style: .bold34TitleLabelStyle)
//
//    // Section title label ("Vaccination title")
//    private let sectionTitleLabel: Labels = {
//        let label = Labels(
//            style: .ordinaryText17LabelStyle,
//            text: String(localized: "vaccination_title_field_title", defaultValue: "Vaccination title")
//        )
//        label.textAlignment = .center
//        return label
//    }()
//
//    // Required text field for vaccination title
//    private let vaccinationTitleContainerView = Views(style: .view12Style)
//    private let vaccinationTitleTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = String(localized: "vaccination_title_placeholder", defaultValue: "Enter title")
//        textField.autocapitalizationType = .words
//        textField.autocorrectionType = .no
//        textField.clearButtonMode = .whileEditing
//        textField.returnKeyType = .done
//        return textField
//    }()
//
//    // Card with date & info
//    private let cardContainerView = Views(style: .view12Style)
//    private let cardVerticalStackView = UIStackView()
//    private let dateAndTimeTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = String(localized: "date_time_placeholder", defaultValue: "Date and time")
//        textField.clearButtonMode = .never
//        // обычное редактируемое поле
//        textField.keyboardType = .numbersAndPunctuation
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        return textField
//    }()
//    private let cardSeparatorView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .separator
//        return view
//    }()
//    private let vaccinationInfoTextView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.isScrollEnabled = false
//        textView.backgroundColor = .clear
//        textView.isOpaque = false
//        textView.text = """
//        Vaccination info:
//        - name of vaccine
//        - vaccine manufacturer
//        - batch number
//        - valid from (date)
//        - valid until (date)
//        - vetclinic and veterinarian
//        """
//        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        textView.textContainer.lineFragmentPadding = 0
//        return textView
//    }()
//
//    // "next time" + Date (side-by-side)
//    private let nextTimeHorizontalStackView = UIStackView()
//    private let nextTimeTitleContainerView = Views(style: .view12Style)
//    private let nextTimeTitleLabel: Labels = {
//        let label = Labels(
//            style: .ordinaryText17LabelStyle,
//            text: String(localized: "next_time_title", defaultValue: "next time")
//        )
//        label.textAlignment = .center
//        return label
//    }()
//    private let nextTimeDateContainerView = Views(style: .view12Style)
//    private let nextTimeDateTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = String(localized: "date_placeholder", defaultValue: "Date")
//        textField.textAlignment = .center
//        return textField
//    }()
//
//    // Upload image block
//    private let uploadContainerView = Views(style: .view12Style)
//    private let uploadTitleLabel: Labels = {
//        let label = Labels(
//            style: .ordinaryText13LabelStyle,
//            text: String(localized: "upload_image_title", defaultValue: "Upload an image")
//        )
//        label.textColor = .secondaryLabel
//        return label
//    }()
//    private let uploadPlaceholderStackView = UIStackView()
//    private let uploadIconImageView: UIImageView = {
//        let view = UIImageView(image: UIImage(systemName: "icloud.and.arrow.up"))
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentMode = .scaleAspectFit
//        view.tintColor = .label
//        return view
//    }()
//    private let uploadPlaceholderLabel = Labels(style: .ordinaryText13LabelStyle, text: "Browse File")
//
//    // Сетка превью
//    private let thumbnailsGridStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.alignment = .fill
//        stack.spacing = 8
//        stack.isHidden = true
//        return stack
//    }()
//
//    // Bottom bar
//    private let bottomBarContainerView = UIView()
//    private lazy var doneButton = Buttons(
//        style: .primary20new(title: String(localized: "done_title", defaultValue: "Done")),
//        target: self,
//        action: #selector(doneTapped)
//    )
//
//    // MARK: - Date handling
//    private let nextTimeDatePicker = UIDatePicker()
//    private let dateTimeFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter
//    }()
//    private let dateOnlyFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter
//    }()
//
//    // MARK: - Images state
//    private var selectedImages: [UIImage] = []
//
//    // MARK: - Init
//    init(petDisplayName: String, petAvatarImageData: Data?, petAvatarFileName: String?) {
//        self.petDisplayName = petDisplayName
//        self.petAvatarImageData = petAvatarImageData
//        self.petAvatarFileName = petAvatarFileName
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
//        configureHeader()
//        configureDatePickers()
//        configureUploadGesture()
//        configureTextViewPlaceholderBehavior()
//        applyPlaceholderTypography()
//        configureTapToDismissEditing()
//        vaccinationTitleTextField.delegate = self
//        scrollView.keyboardDismissMode = .onDrag
//    }
//
//    // MARK: - Setup
//    private func setupNavigation() {
//        let closeButton = UIBarButtonItem(
//            image: UIImage(systemName: "xmark"),
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
//        navigationItem.rightBarButtonItem = closeButton
//    }
//
//    private func configureTapToDismissEditing() {
//        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss))
//        tapToDismiss.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapToDismiss)
//    }
//
//    private func configureHeader() {
//        petNameLabel.text = petDisplayName.nilIfBlank
//            ?? String(localized: "name_title", defaultValue: "Name")
//
//        if let data = petAvatarImageData, let image = UIImage(data: data) {
//            avatarImageView.image = image
//        } else if let file = petAvatarFileName {
//            avatarImageView.image = UIImage.loadOrPlaceholder(named: file, in: traitCollection)
//        } else {
//            avatarImageView.image = UIImage(named: "no photo")
//        }
//    }
//
//    private func configureDatePickers() {
//        nextTimeDatePicker.datePickerMode = .date
//        if #available(iOS 13.4, *) { nextTimeDatePicker.preferredDatePickerStyle = .wheels }
//        nextTimeDatePicker.addTarget(self, action: #selector(nextTimePickerChanged), for: .valueChanged)
//        nextTimeDateTextField.inputView = nextTimeDatePicker
//        nextTimeDateTextField.inputAccessoryView = makeAccessoryToolbar(selector: #selector(doneForNextTime))
//    }
//
//    private func makeAccessoryToolbar(selector: Selector) -> UIToolbar {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let flexible = UIBarButtonItem(systemItem: .flexibleSpace)
//        let done = UIBarButtonItem(title: String(localized: "done_title", defaultValue: "Done"),
//                                   style: .done,
//                                   target: self,
//                                   action: selector)
//        toolbar.items = [flexible, done]
//        return toolbar
//    }
//
//    private func applyPlaceholderTypography() {
//        // у placeholder UITextField используется тот же font, что и у textField
//        let placeholderFont = dateAndTimeTextField.font ?? UIFont.systemFont(ofSize: 17)
//        vaccinationInfoTextView.font = placeholderFont
//        vaccinationInfoTextView.textColor = .placeholderText
//    }
//
//    private func configureUploadGesture() {
//        uploadContainerView.isUserInteractionEnabled = true
//        uploadPlaceholderStackView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImageTapped))
//        uploadContainerView.addGestureRecognizer(tap)
//        uploadPlaceholderStackView.addGestureRecognizer(tap)
//    }
//
//    private func configureTextViewPlaceholderBehavior() {
//        vaccinationInfoTextView.delegate = self
//    }
//
//    // MARK: - Actions
//    @objc private func closeTapped() {
//        if let nav = navigationController, nav.presentingViewController != nil {
//            nav.dismiss(animated: true)
//        } else if presentingViewController != nil {
//            dismiss(animated: true)
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//
//    @objc private func handleTapToDismiss() {
//        view.endEditing(true)
//    }
//
//    @objc private func doneTapped() {
//        // Validation: Vaccination title is required
//        let titleText = (vaccinationTitleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !titleText.isEmpty else {
//            let alert = UIAlertController(
//                title: String(localized: "vaccination_title_required_title", defaultValue: "Title required"),
//                message: String(localized: "vaccination_title_required_msg", defaultValue: "Please enter the vaccination title."),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
//                self?.vaccinationTitleTextField.becomeFirstResponder()
//            }))
//            present(alert, animated: true)
//            return
//        }
//
//        // Пока без сохранения — просто закрываем экран.
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc private func nextTimePickerChanged() {
//        nextTimeDateTextField.text = dateOnlyFormatter.string(from: nextTimeDatePicker.date)
//    }
//    @objc private func doneForNextTime() { nextTimeDateTextField.resignFirstResponder() }
//
//    @objc private func pickImageTapped() {
//        if #available(iOS 14, *) {
//            var configuration = PHPickerConfiguration(photoLibrary: .shared())
//            configuration.filter = .images
//            configuration.selectionLimit = 0 // мультивыбор
//            let picker = PHPickerViewController(configuration: configuration)
//            picker.delegate = self
//            present(picker, animated: true)
//        } else {
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            picker.allowsEditing = false
//            present(picker, animated: true)
//        }
//    }
//
//    // MARK: - Thumbnails rendering
//    private func refreshThumbnailsGrid() {
//        let hasImages = !selectedImages.isEmpty
//        uploadPlaceholderStackView.isHidden = hasImages
//        thumbnailsGridStackView.isHidden = !hasImages
//
//        thumbnailsGridStackView.arrangedSubviews.forEach { row in
//            thumbnailsGridStackView.removeArrangedSubview(row)
//            row.removeFromSuperview()
//        }
//
//        guard hasImages else { return }
//
//        let itemsPerRow = 3
//        let thumbnailSide: CGFloat = 88
//        let spacing: CGFloat = 8
//
//        var currentIndex = 0
//        while currentIndex < selectedImages.count {
//            let rowStack = UIStackView()
//            rowStack.axis = .horizontal
//            rowStack.alignment = .fill
//            rowStack.spacing = spacing
//            rowStack.distribution = .fillEqually
//
//            for column in 0..<itemsPerRow {
//                if currentIndex + column < selectedImages.count {
//                    let imageView = UIImageView()
//                    imageView.translatesAutoresizingMaskIntoConstraints = false
//                    imageView.contentMode = .scaleAspectFill
//                    imageView.clipsToBounds = true
//                    imageView.layer.cornerRadius = 12
//                    imageView.image = selectedImages[currentIndex + column]
//                    imageView.isUserInteractionEnabled = true
//                    imageView.tag = currentIndex + column
//
//                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleRemoveImageGesture(_:)))
//                    imageView.addGestureRecognizer(longPress)
//
//                    rowStack.addArrangedSubview(imageView)
//                    imageView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                } else {
//                    let spacer = UIView()
//                    spacer.translatesAutoresizingMaskIntoConstraints = false
//                    rowStack.addArrangedSubview(spacer)
//                    spacer.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
//                }
//            }
//
//            thumbnailsGridStackView.addArrangedSubview(rowStack)
//            currentIndex += itemsPerRow
//        }
//    }
//
//    @objc private func handleRemoveImageGesture(_ gesture: UILongPressGestureRecognizer) {
//        guard gesture.state == .began, let view = gesture.view else { return }
//        let index = view.tag
//        guard index < selectedImages.count else { return }
//
//        let alert = UIAlertController(
//            title: String(localized: "remove_photo_title", defaultValue: "Remove photo?"),
//            message: nil,
//            preferredStyle: .actionSheet
//        )
//        alert.addAction(UIAlertAction(
//            title: String(localized: "remove_title", defaultValue: "Remove"),
//            style: .destructive,
//            handler: { [weak self] _ in
//                guard let self else { return }
//                self.selectedImages.remove(at: index)
//                self.refreshThumbnailsGrid()
//            })
//        )
//        alert.addAction(UIAlertAction(title: String(localized: "cancel_title", defaultValue: "Cancel"), style: .cancel))
//        present(alert, animated: true)
//    }
//}
//
//// MARK: - Layout
//private extension CreateNewVaccinationViewController {
//    func setupViewsAndConstraints() {
//        // Root hierarchy
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
//        contentStackView.translatesAutoresizingMaskIntoConstraints = false
//        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(scrollView)
//        view.addSubview(bottomBarContainerView)
//        scrollView.addSubview(contentContainerView)
//        contentContainerView.addSubview(contentStackView)
//
//        // Stack config
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
//        // Vaccination title container
//        vaccinationTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
//        vaccinationTitleContainerView.backgroundColor = .secondarySystemBackground
//        vaccinationTitleContainerView.addSubview(vaccinationTitleTextField)
//
//        // Card with inputs
//        cardContainerView.backgroundColor = .secondarySystemBackground
//        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
//        cardVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        cardVerticalStackView.axis = .vertical
//        cardVerticalStackView.alignment = .fill
//        cardVerticalStackView.spacing = 12
//        cardContainerView.addSubview(cardVerticalStackView)
//
//        // Horizontal "next time" line
//        nextTimeHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        nextTimeHorizontalStackView.axis = .horizontal
//        nextTimeHorizontalStackView.spacing = 16
//        nextTimeHorizontalStackView.distribution = .fillEqually
//
//        nextTimeTitleContainerView.backgroundColor = .secondarySystemBackground
//        nextTimeDateContainerView.backgroundColor = .secondarySystemBackground
//
//        nextTimeTitleContainerView.addSubview(nextTimeTitleLabel)
//        nextTimeDateContainerView.addSubview(nextTimeDateTextField)
//
//        // Upload
//        uploadContainerView.backgroundColor = .secondarySystemBackground
//        uploadContainerView.translatesAutoresizingMaskIntoConstraints = false
//        uploadTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        uploadPlaceholderStackView.translatesAutoresizingMaskIntoConstraints = false
//        uploadPlaceholderStackView.axis = .vertical
//        uploadPlaceholderStackView.alignment = .center
//        uploadPlaceholderStackView.spacing = 8
//        uploadPlaceholderStackView.addArrangedSubview(uploadIconImageView)
//        uploadPlaceholderStackView.addArrangedSubview(uploadPlaceholderLabel)
//
//        uploadContainerView.addSubview(uploadTitleLabel)
//        uploadContainerView.addSubview(uploadPlaceholderStackView)
//        uploadContainerView.addSubview(thumbnailsGridStackView)
//
//        // Assemble into main stack
//        contentStackView.addArrangedSubview(headerContainerView)
//        contentStackView.addArrangedSubview(sectionTitleLabel)
//        contentStackView.addArrangedSubview(vaccinationTitleContainerView)
//        contentStackView.addArrangedSubview(cardContainerView)
//        contentStackView.addArrangedSubview(nextTimeHorizontalStackView)
//        contentStackView.addArrangedSubview(uploadContainerView)
//
//        // Bottom bar
//        let readable = bottomBarContainerView.readableContentGuide
//        bottomBarContainerView.addSubview(doneButton)
//
//        // Constraints
//        NSLayoutConstraint.activate([
//            // Scroll scaffold
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomBarContainerView.topAnchor),
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
//            // Header
//            headerHorizontalStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
//            headerHorizontalStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
//            headerHorizontalStackView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
//            headerHorizontalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainerView.leadingAnchor),
//            headerHorizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: headerContainerView.trailingAnchor),
//
//            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
//            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),
//
//            // Vaccination title text field in container
//            vaccinationTitleTextField.leadingAnchor.constraint(equalTo: vaccinationTitleContainerView.leadingAnchor, constant: 12),
//            vaccinationTitleTextField.trailingAnchor.constraint(equalTo: vaccinationTitleContainerView.trailingAnchor, constant: -12),
//            vaccinationTitleTextField.topAnchor.constraint(equalTo: vaccinationTitleContainerView.topAnchor, constant: 10),
//            vaccinationTitleTextField.bottomAnchor.constraint(equalTo: vaccinationTitleContainerView.bottomAnchor, constant: -10),
//            vaccinationTitleTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
//
//            // Card container internal
//            cardVerticalStackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
//            cardVerticalStackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
//            cardVerticalStackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
//            cardVerticalStackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),
//
//            dateAndTimeTextField.heightAnchor.constraint(equalToConstant: 44),
//            cardSeparatorView.heightAnchor.constraint(equalToConstant: 1),
//
//            // Next time row
//            nextTimeTitleLabel.centerXAnchor.constraint(equalTo: nextTimeTitleContainerView.centerXAnchor),
//            nextTimeTitleLabel.centerYAnchor.constraint(equalTo: nextTimeTitleContainerView.centerYAnchor),
//
//            nextTimeDateTextField.centerXAnchor.constraint(equalTo: nextTimeDateContainerView.centerXAnchor),
//            nextTimeDateTextField.centerYAnchor.constraint(equalTo: nextTimeDateContainerView.centerYAnchor),
//
//            nextTimeTitleContainerView.heightAnchor.constraint(equalToConstant: 44),
//            nextTimeDateContainerView.heightAnchor.constraint(equalToConstant: 44),
//
//            // Upload
//            uploadTitleLabel.topAnchor.constraint(equalTo: uploadContainerView.topAnchor, constant: 12),
//            uploadTitleLabel.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor, constant: 12),
//            uploadTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: uploadContainerView.trailingAnchor, constant: -12),
//
//            uploadPlaceholderStackView.centerXAnchor.constraint(equalTo: uploadContainerView.centerXAnchor),
//            uploadPlaceholderStackView.centerYAnchor.constraint(equalTo: uploadContainerView.centerYAnchor),
//            uploadIconImageView.widthAnchor.constraint(equalToConstant: 36),
//            uploadIconImageView.heightAnchor.constraint(equalToConstant: 36),
//
//            thumbnailsGridStackView.topAnchor.constraint(equalTo: uploadTitleLabel.bottomAnchor, constant: 12),
//            thumbnailsGridStackView.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor, constant: 12),
//            thumbnailsGridStackView.trailingAnchor.constraint(equalTo: uploadContainerView.trailingAnchor, constant: -12),
//            thumbnailsGridStackView.bottomAnchor.constraint(equalTo: uploadContainerView.bottomAnchor, constant: -12),
//
//            uploadContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220),
//
//            // Bottom bar
//            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            doneButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
//            doneButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
//            doneButton.topAnchor.constraint(equalTo: bottomBarContainerView.topAnchor, constant: 8),
//            doneButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
//            doneButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
//            doneButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
//        ])
//
//        // Build card content order
//        cardVerticalStackView.addArrangedSubview(dateAndTimeTextField)
//        cardVerticalStackView.addArrangedSubview(cardSeparatorView)
//        cardVerticalStackView.addArrangedSubview(vaccinationInfoTextView)
//
//        // Build next-time row
//        nextTimeHorizontalStackView.addArrangedSubview(nextTimeTitleContainerView)
//        nextTimeHorizontalStackView.addArrangedSubview(nextTimeDateContainerView)
//    }
//}
//
//// MARK: - TextView placeholder handling
//extension CreateNewVaccinationViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .placeholderText {
//            textView.text = nil
//            textView.textColor = .label
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if (textView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            textView.text = """
//            Vaccination info:
//            - name of vaccine
//            - vaccine manufacturer
//            - batch number
//            - valid from (date)
//            - valid until (date)
//            - vetclinic and veterinarian
//            """
//            applyPlaceholderTypography()
//        }
//    }
//}
//
//// MARK: - Title field return key
//extension CreateNewVaccinationViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField === vaccinationTitleTextField {
//            textField.resignFirstResponder()
//            return false
//        }
//        return true
//    }
//}
//
//// MARK: - Image picking
//@available(iOS 14, *)
//extension CreateNewVaccinationViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        dismiss(animated: true)
//        guard !results.isEmpty else { return }
//
//        let dispatchGroup = DispatchGroup()
//        var newImages: [UIImage] = []
//
//        for result in results {
//            let provider = result.itemProvider
//            guard provider.canLoadObject(ofClass: UIImage.self) else { continue }
//            dispatchGroup.enter()
//            provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
//                defer { dispatchGroup.leave() }
//                guard let _ = self, let image = object as? UIImage else { return }
//                let resized = image.resizedToFit(maxDimension: 1600)
//                newImages.append(resized)
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            self.selectedImages.append(contentsOf: newImages)
//            self.refreshThumbnailsGrid()
//        }
//    }
//}
//
//extension CreateNewVaccinationViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss(animated: true) }
//
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        dismiss(animated: true)
//        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
//            selectedImages.append(image.resizedToFit(maxDimension: 1600))
//            refreshThumbnailsGrid()
//        }
//    }
//}

import UIKit
import PhotosUI

final class CreateNewVaccinationViewController: UIViewController {

    // MARK: - Header data
    private let petDisplayName: String
    private let petAvatarImageData: Data?
    private let petAvatarFileName: String?
    private let petId: UUID?                     // НУЖЕН для сохранения

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
        let label = Labels(style: .ordinaryText17LabelStyle,
                           text: String(localized: "vaccination_title_field_title",
                                        defaultValue: "Vaccination title"))
        label.textAlignment = .center
        return label
    }()
    private let vaccinationTitleContainerView = Views(style: .view12Style)
    private let vaccinationTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "vaccination_title_placeholder",
                                       defaultValue: "Enter title")
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        return textField
    }()

    // Card with date & info
    private let cardContainerView = Views(style: .view12Style)
    private let cardVerticalStackView = UIStackView()
    private let dateAndTimeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "date_time_placeholder", defaultValue: "Date and time")
        textField.clearButtonMode = .never
        textField.keyboardType = .numbersAndPunctuation
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
        let label = Labels(style: .ordinaryText17LabelStyle,
                           text: String(localized: "next_time_title", defaultValue: "next time"))
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
        let label = Labels(style: .ordinaryText13LabelStyle,
                           text: String(localized: "upload_image_title", defaultValue: "Upload an image"))
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
    private let nextTimeDatePicker = UIDatePicker()
    private let dateTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()
    private let dateOnlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    // MARK: - Images
    private var selectedImages: [UIImage] = []

    // MARK: - Init
    init(petDisplayName: String, petAvatarImageData: Data?, petAvatarFileName: String?, petId: UUID?) {
        self.petDisplayName = petDisplayName
        self.petAvatarImageData = petAvatarImageData
        self.petAvatarFileName = petAvatarFileName
        self.petId = petId
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
    }

    // MARK: - Setup
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeButton
    }

    private func configureTapToDismissEditing() {
        let g = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss))
        g.cancelsTouchesInView = false
        view.addGestureRecognizer(g)
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
        nextTimeDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { nextTimeDatePicker.preferredDatePickerStyle = .wheels }
        nextTimeDatePicker.addTarget(self, action: #selector(nextTimePickerChanged), for: .valueChanged)
        nextTimeDateTextField.inputView = nextTimeDatePicker
        nextTimeDateTextField.inputAccessoryView = makeAccessoryToolbar(selector: #selector(doneForNextTime))
    }

    private func makeAccessoryToolbar(selector: Selector) -> UIToolbar {
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(systemItem: .flexibleSpace)
        let done = UIBarButtonItem(title: String(localized: "done_title", defaultValue: "Done"),
                                   style: .done,
                                   target: self,
                                   action: selector)
        bar.items = [flex, done]
        return bar
    }

    private func applyPlaceholderTypography() {
        let placeholderFont = dateAndTimeTextField.font ?? UIFont.systemFont(ofSize: 17)
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

    // MARK: - Actions
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
        // 0) Обязательный petId
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

        // 1) Валидация заголовка
        let titleText = (vaccinationTitleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !titleText.isEmpty else { /* показываешь алерт и return */ return }

        // 2) Парсинг даты
        let dateString = (dateAndTimeTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let parsedDate = parseDate(from: dateString)

        // 3) Заметки
        let notes: String?
        if vaccinationInfoTextView.textColor == .placeholderText {
            notes = nil
        } else {
            let raw = vaccinationInfoTextView.text ?? ""
            notes = raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : raw
        }

        // 4) Сохранение — без if let
        VaccinationsStorage.shared.createVaccination(
            forPetId: petId,
            title: titleText,
            dateGiven: parsedDate,
            notes: notes,
            images: selectedImages
        )

        // 5) Назад
        navigationController?.popViewController(animated: true)
    }


    @objc private func nextTimePickerChanged() {
        nextTimeDateTextField.text = dateOnlyFormatter.string(from: nextTimeDatePicker.date)
    }
    @objc private func doneForNextTime() { nextTimeDateTextField.resignFirstResponder() }

    @objc private func pickImageTapped() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            config.selectionLimit = 0 // multi-select
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

    // MARK: - Helpers
    /// Пытаемся распознать разные вводы даты/времени.
    private func parseDate(from string: String) -> Date? {
        guard !string.isEmpty else { return nil }
        // 1) Сначала — локальный формат medium/short
        if let d = dateTimeFormatter.date(from: string) { return d }

        // 2) Популярные паттерны
        let patterns = [
            "dd.MM.yyyy HH:mm", "dd.MM.yy HH:mm",
            "dd/MM/yyyy HH:mm", "yyyy-MM-dd HH:mm",
            "dd.MM.yyyy", "dd.MM.yy", "yyyy-MM-dd",
            "HH:mm dd.MM.yyyy"
        ]
        let f = DateFormatter()
        f.locale = .current
        for p in patterns {
            f.dateFormat = p
            if let d = f.date(from: string) { return d }
        }

        // 3) ISO8601
        let iso = ISO8601DateFormatter()
        if let d = iso.date(from: string) { return d }

        return nil
    }

    // Рендер сетки превью
    private func refreshThumbnailsGrid() {
        let hasImages = !selectedImages.isEmpty
        uploadPlaceholderStackView.isHidden = hasImages
        thumbnailsGridStackView.isHidden = !hasImages

        thumbnailsGridStackView.arrangedSubviews.forEach { row in
            thumbnailsGridStackView.removeArrangedSubview(row); row.removeFromSuperview()
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
                if currentIndex + column < selectedImages.count {
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.layer.cornerRadius = 12
                    imageView.image = selectedImages[currentIndex + column]
                    imageView.tag = currentIndex + column
                    let longPress = UILongPressGestureRecognizer(target: self,
                                                                 action: #selector(handleRemoveImageGesture(_:)))
                    imageView.addGestureRecognizer(longPress)
                    imageView.isUserInteractionEnabled = true

                    row.addArrangedSubview(imageView)
                    imageView.heightAnchor.constraint(equalToConstant: thumbnailSide).isActive = true
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

    @objc private func handleRemoveImageGesture(_ g: UILongPressGestureRecognizer) {
        guard g.state == .began, let view = g.view else { return }
        let index = view.tag
        guard index < selectedImages.count else { return }
        let ac = UIAlertController(title: String(localized: "remove_photo_title", defaultValue: "Remove photo?"),
                                   message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: String(localized: "remove_title", defaultValue: "Remove"),
                                   style: .destructive, handler: { [weak self] _ in
            self?.selectedImages.remove(at: index)
            self?.refreshThumbnailsGrid()
        }))
        ac.addAction(UIAlertAction(title: String(localized: "cancel_title", defaultValue: "Cancel"),
                                   style: .cancel))
        present(ac, animated: true)
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

            dateAndTimeTextField.heightAnchor.constraint(equalToConstant: 44),
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
        cardVerticalStackView.addArrangedSubview(dateAndTimeTextField)
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
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            selectedImages.append(image.resizedToFit(maxDimension: 1600))
            refreshThumbnailsGrid()
        }
    }
}
