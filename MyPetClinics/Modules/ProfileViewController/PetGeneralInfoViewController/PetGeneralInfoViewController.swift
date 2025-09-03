//
//  PetGeneralInfoViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.8.2025.
//

import UIKit

protocol PetGeneralInfoViewControllerDelegate: AnyObject {
    func petGeneralInfoViewController(_ controller: PetGeneralInfoViewController, didFinishWith data: PetProfileFormData)
}

final class PetGeneralInfoViewController: UIViewController {

    // MARK: - Public
    weak var delegate: PetGeneralInfoViewControllerDelegate?

    // MARK: - State
    private var data: PetProfileFormData

    // MARK: - UI
    private let contentContainerView = UIView()
    private let cardView = FormCardView()
    private let rowsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        return stack
    }()

    private let nameRow = FormTextFieldRow(placeholder: String(localized: "name_title", defaultValue: "Name"))
    private let fullNameRow = FormTextFieldRow(placeholder: String(localized: "full_name_title", defaultValue: "Full Name"))
    private let sexRow = FormPickerTextFieldRow(placeholder: String(localized: "sex_title", defaultValue: "Sex"))
    private let speciesRow = FormPickerTextFieldRow(placeholder: String(localized: "species_title", defaultValue: "Species (cat, dog, etc.)"))
    private let breedRow = FormTextFieldRow(placeholder: String(localized: "breed_title", defaultValue: "Breed"))
    private let colorRow = FormTextFieldRow(placeholder: String(localized: "color_markings_title", defaultValue: "Color/markings"))
    private let dateOfBirthRow = FormDateTextFieldRow(placeholder: String(localized: "dob_title", defaultValue: "Date of birth"))
    private let weightRow = FormTextFieldRow(placeholder: String(localized: "weight_title", defaultValue: "Weight"))
    private let identificationRow = FormPickerTextFieldRow(
        placeholder: String(localized: "ident_combined_title", defaultValue: "Identification (microchip/tattoo and number)")
    )

    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title", defaultValue: "Done")),
        target: self,
        action: #selector(doneTapped)
    )

    // MARK: - Init
    init(initial: PetProfileFormData) {
        self.data = initial
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = String(localized: "general_info_title", defaultValue: "General info")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityLabel =
            String(localized: "close_title", defaultValue: "Close")
        
        setupViews()
        fillInitialValues()
        wireUpEvents()
    }

    // MARK: - Setup
    private func setupViews() {
        // контейнеры
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainerView)
        view.addSubview(bottomBarContainerView)

        // card
        contentContainerView.addSubview(cardView)
        cardView.addSubview(rowsStackView)

        // порядок строк строго как в макете
        addRow(nameRow)
        addSeparator()
        addRow(fullNameRow)
        addSeparator()
        addRow(sexRow)
        addSeparator()
        addRow(speciesRow)
        addSeparator()
        addRow(breedRow)
        addSeparator()
        addRow(colorRow)
        addSeparator()
        addRow(dateOfBirthRow)
        addSeparator()
        addRow(weightRow)
        addSeparator()
        addRow(identificationRow)

        // нижняя кнопка
        bottomBarContainerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        // constraints
        let readable = bottomBarContainerView.readableContentGuide
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bottomBarContainerView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            bottomBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cardView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),

            rowsStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            rowsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            rowsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            doneButton.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            doneButton.centerXAnchor.constraint(equalTo: bottomBarContainerView.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: bottomBarContainerView.bottomAnchor, constant: -8),
            doneButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])

        // клавиатуры
        weightRow.textField.keyboardType = .decimalPad

        // пикеры – набор опций без выбора по умолчанию
        sexRow.setOptions([PetSex.male.localizedTitle, PetSex.female.localizedTitle], selectedIndex: nil)
        speciesRow.setOptions([
            String(localized: "cat_title", defaultValue: "Cat"),
            String(localized: "dog_title", defaultValue: "Dog"),
            String(localized: "other_write_title", defaultValue: "Other (write)")
        ], selectedIndex: nil)

        identificationRow.setOptions([
            String(localized: "ident_none_title", defaultValue: "None"),
            String(localized: "ident_microchip_title", defaultValue: "Microchip"),
            String(localized: "ident_tattoo_title", defaultValue: "Tattoo")
        ], selectedIndex: nil)

        // стрелочки «вниз» для Sex и Species (как в макете)
        addDropdownIndicator(to: sexRow.textField)
        addDropdownIndicator(to: speciesRow.textField)
    }

    private func addRow(_ row: UIView) {
        rowsStackView.addArrangedSubview(row)
    }
    private func addSeparator() {
        rowsStackView.addArrangedSubview(FormSeparatorView())
    }

    /// Добавляет иконку chevron.down справа у текстфилда и прячет курсор (как у выпадашки)
    private func addDropdownIndicator(to textField: UITextField) {
        let icon = UIImageView(image: UIImage(systemName: "chevron.down"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .tertiaryLabel

        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 22),
            container.heightAnchor.constraint(equalToConstant: 18)
        ])

        textField.rightView = container
        textField.rightViewMode = .always
        textField.tintColor = .clear // скрыть каретку, чтобы ощущалось как picker
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        textField.accessibilityTraits.insert(.button)
    }

    // MARK: - Initial values
    private func fillInitialValues() {
        nameRow.textField.text = data.name
        fullNameRow.textField.text = data.fullName
        breedRow.textField.text = data.breed
        colorRow.textField.text = data.colorMarkings

        if let date = data.dateOfBirth {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            dateOfBirthRow.textField.text = formatter.string(from: date)
        }

        if let weight = data.weightInKilograms {
            weightRow.textField.text = String(weight)
        }

        // Sex — выбранный индекс
        if let sex = data.sex {
            let index = (sex == .male) ? 0 : 1
            sexRow.setOptions([PetSex.male.localizedTitle, PetSex.female.localizedTitle], selectedIndex: index)
        }

        // Species — Cat/Dog/Other
        switch data.species {
        case .cat:
            speciesRow.setOptions([
                String(localized: "cat_title", defaultValue: "Cat"),
                String(localized: "dog_title", defaultValue: "Dog"),
                String(localized: "other_write_title", defaultValue: "Other (write)")
            ], selectedIndex: 0)
        case .dog:
            speciesRow.setOptions([
                String(localized: "cat_title", defaultValue: "Cat"),
                String(localized: "dog_title", defaultValue: "Dog"),
                String(localized: "other_write_title", defaultValue: "Other (write)")
            ], selectedIndex: 1)
        case .other(let custom):
            if !custom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                speciesRow.textField.text = custom
            }
        }

        // Identification — показываем строкой, если задано
        if data.identificationType != .none,
           let number = data.identificationNumber,
           !number.isEmpty {
            identificationRow.textField.text = "\(data.identificationType.localizedTitle) \(number)"
        }
    }

    // MARK: - Events wiring
    private func wireUpEvents() {
        nameRow.textField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        fullNameRow.textField.addTarget(self, action: #selector(fullNameChanged), for: .editingChanged)
        breedRow.textField.addTarget(self, action: #selector(breedChanged), for: .editingChanged)
        colorRow.textField.addTarget(self, action: #selector(colorChanged), for: .editingChanged)
        weightRow.textField.addTarget(self, action: #selector(weightChanged), for: .editingChanged)

        dateOfBirthRow.onDidPickDate = { [weak self] date in
            self?.data.dateOfBirth = date
        }

        sexRow.onDidSelectIndex = { [weak self] index in
            guard let self else { return }
            self.data.sex = (index == 0) ? .male : .female
        }

        speciesRow.onDidSelectIndex = { [weak self] index in
            guard let self else { return }
            switch index {
            case 0:
                self.data.species = .cat
                self.speciesRow.textField.text = String(localized: "cat_title", defaultValue: "Cat")
            case 1:
                self.data.species = .dog
                self.speciesRow.textField.text = String(localized: "dog_title", defaultValue: "Dog")
            case 2:
                self.askCustomSpecies()
            default:
                break
            }
        }

        identificationRow.onDidSelectIndex = { [weak self] index in
            guard let self else { return }
            if index == 0 {
                self.data.identificationType = .none
                self.data.identificationNumber = nil
                self.identificationRow.textField.text = nil // по макету плейсхолдер, а не «None»
            } else {
                let chosen: PetIdentificationType = (index == 1) ? .microchip : .tattoo
                self.askIdentificationNumber(for: chosen)
            }
        }
    }

    // MARK: - Helpers (alerts)
    private func askCustomSpecies() {
        let alert = UIAlertController(
            title: String(localized: "enter_species_title", defaultValue: "Enter species"),
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { tf in
            tf.placeholder = String(localized: "species_placeholder", defaultValue: "e.g. Parrot")
            if case .other(let custom) = self.data.species, !custom.isEmpty {
                tf.text = custom
            }
        }
        alert.addAction(UIAlertAction(title: String(localized: "cancel_title", defaultValue: "Cancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: String(localized: "done_title", defaultValue: "Done"), style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let value = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.data.species = .other(value)
            self.speciesRow.textField.text = value.isEmpty
                ? String(localized: "other_title", defaultValue: "Other")
                : value
        }))
        present(alert, animated: true)
    }

    private func askIdentificationNumber(for type: PetIdentificationType) {
        let alert = UIAlertController(
            title: type.localizedTitle,
            message: String(localized: "enter_id_number_title", defaultValue: "Enter number"),
            preferredStyle: .alert
        )
        alert.addTextField { tf in
            tf.keyboardType = .asciiCapable
            tf.autocapitalizationType = .allCharacters
            tf.placeholder = String(localized: "number_placeholder", defaultValue: "Number")
            tf.text = self.data.identificationNumber
        }
        alert.addAction(UIAlertAction(title: String(localized: "cancel_title", defaultValue: "Cancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: String(localized: "done_title", defaultValue: "Done"), style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let number = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let number, !number.isEmpty {
                self.data.identificationType = type
                self.data.identificationNumber = number
                self.identificationRow.textField.text = "\(type.localizedTitle) \(number)"
            } else {
                self.identificationRow.textField.text = nil
            }
        }))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        // если показан модально – закрываем модалку
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }
        // если находимся в навигации:
        if let nav = navigationController {
            // если этот контроллер — корневой в модально показанном UINavigationController
            if nav.viewControllers.first === self, nav.presentingViewController != nil {
                nav.dismiss(animated: true)
            } else {
                // иначе выходим из потока целиком
                nav.popToRootViewController(animated: true)
            }
            return
        }
        // запасной вариант
        dismiss(animated: true)
    }
    
    @objc private func nameChanged() {
        data.name = nameRow.textField.text ?? ""
    }
    @objc private func fullNameChanged() {
        data.fullName = fullNameRow.textField.text?.nilIfBlank
    }
    @objc private func breedChanged() {
        data.breed = breedRow.textField.text?.nilIfBlank
    }
    @objc private func colorChanged() {
        data.colorMarkings = colorRow.textField.text?.nilIfBlank
    }
    @objc private func weightChanged() {
        let raw = (weightRow.textField.text ?? "").replacingOccurrences(of: ",", with: ".")
        data.weightInKilograms = Double(raw)
    }

    @objc private func doneTapped() {
        // Name
        data.name = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !data.name.isEmpty else {
            let alert = UIAlertController(
                title: String(localized: "name_required_title", defaultValue: "Name required"),
                message: String(localized: "name_required_msg", defaultValue: "Please enter pet’s name."),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Species (обязательное)
        let speciesIsValid: Bool = {
            switch data.species {
            case .cat, .dog: return true
            case .other(let custom):
                return !custom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
        
        delegate?.petGeneralInfoViewController(self, didFinishWith: data)
    }
}


