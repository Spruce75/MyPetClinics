//
//  OwnersViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 8.9.2025.
//

import UIKit

protocol OwnersViewControllerDelegate: AnyObject {
    func ownersViewController(_ controller: OwnersViewController, didFinishWith owners: [OwnersViewController.OwnerFormData])
}

final class OwnersViewController: UIViewController {
    
    // MARK: - Public types
    struct OwnerFormData {
        var fullName: String?
        var address: String?
        var contactDetails: String?
    }
    
    // MARK: - Public
    weak var delegate: OwnersViewControllerDelegate?
    
    // MARK: - State
    private var owners: [OwnerFormData]
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    private let contentStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .fill
        s.spacing = 24
        return s
    }()
    
    // Owner 1
    private let owner1TitleLabel = Labels(style: .bold20LabelStyle, text: String(localized: "owner1_main_title", defaultValue: "Owner 1 (Main)"))
    private let owner1CardView = FormCardView()
    private let owner1NameRow = FormTextFieldRow(placeholder: String(localized: "full_name_title", defaultValue: "Full Name"))
    private let owner1AddressRow = FormTextFieldRow(placeholder: String(localized: "address_title", defaultValue: "Address"))
    private let owner1ContactsRow = FormTextFieldRow(placeholder: String(localized: "contact_details_title", defaultValue: "Contact details"))
    
    // Owner 2
    private let owner2TitleLabel = Labels(style: .bold20LabelStyle, text: String(localized: "owner2_title", defaultValue: "Owner 2"))
    private let owner2CardView = FormCardView()
    private let owner2NameRow = FormTextFieldRow(placeholder: String(localized: "full_name_title", defaultValue: "Full Name"))
    private let owner2AddressRow = FormTextFieldRow(placeholder: String(localized: "address_title", defaultValue: "Address"))
    private let owner2ContactsRow = FormTextFieldRow(placeholder: String(localized: "contact_details_title", defaultValue: "Contact details"))
    
    // Owner 3
    private let owner3TitleLabel = Labels(style: .bold20LabelStyle, text: String(localized: "owner3_title", defaultValue: "Owner 3"))
    private let owner3CardView = FormCardView()
    private let owner3NameRow = FormTextFieldRow(placeholder: String(localized: "full_name_title", defaultValue: "Full Name"))
    private let owner3AddressRow = FormTextFieldRow(placeholder: String(localized: "address_title", defaultValue: "Address"))
    private let owner3ContactsRow = FormTextFieldRow(placeholder: String(localized: "contact_details_title", defaultValue: "Contact details"))
    
    // Bottom bar
    private let bottomBarContainerView = UIView()
    private lazy var doneButton = Buttons(
        style: .primary20new(title: String(localized: "done_title", defaultValue: "Done")),
        target: self,
        action: #selector(doneTapped)
    )
    
    // MARK: - Init
    /// Можно передать начальные значения (по умолчанию — три пустых владельца)
    init(initialOwners: [OwnerFormData]? = nil) {
        if let initialOwners, !initialOwners.isEmpty {
            // ровно 3 слота
            self.owners = Array(initialOwners.prefix(3)) + Array(repeating: OwnerFormData(), count: max(0, 3 - initialOwners.count))
        } else {
            self.owners = [OwnerFormData(), OwnerFormData(), OwnerFormData()]
        }
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupViewsAndConstraints()
        configureReturnKeyChains()
        fillInitialValues()
        wireUpEvents()
    }
    
    // MARK: - Navigation
    private func setupNavigation() {
        navigationItem.title = String(localized: "set_up_owners_title", defaultValue: "Set up Owners")
        // крестик справа — закрыть весь поток, как в макетах
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
    }
    
    // MARK: - Private helpers
    private func buildCard(_ card: FormCardView, rows: [UIView]) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        
        for (idx, row) in rows.enumerated() {
            stack.addArrangedSubview(row)
            if idx < rows.count - 1 {
                stack.addArrangedSubview(FormSeparatorView())
            }
        }
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureReturnKeyChains() {
        // по рядам — Next/Done
        [owner1NameRow.textField, owner1AddressRow.textField].forEach { $0.returnKeyType = .next }
        [owner2NameRow.textField, owner2AddressRow.textField].forEach { $0.returnKeyType = .next }
        [owner3NameRow.textField, owner3AddressRow.textField].forEach { $0.returnKeyType = .next }
        
        [owner1ContactsRow.textField, owner2ContactsRow.textField, owner3ContactsRow.textField].forEach {
            $0.returnKeyType = .done
            $0.addTarget(self, action: #selector(returnKeyDonePressed), for: .editingDidEndOnExit)
        }
    }
    
    private func fillInitialValues() {
        // Owner 1
        owner1NameRow.textField.text = owners[0].fullName
        owner1AddressRow.textField.text = owners[0].address
        owner1ContactsRow.textField.text = owners[0].contactDetails
        
        // Owner 2
        owner2NameRow.textField.text = owners[1].fullName
        owner2AddressRow.textField.text = owners[1].address
        owner2ContactsRow.textField.text = owners[1].contactDetails
        
        // Owner 3
        owner3NameRow.textField.text = owners[2].fullName
        owner3AddressRow.textField.text = owners[2].address
        owner3ContactsRow.textField.text = owners[2].contactDetails
    }
    
    private func wireUpEvents() {
        owner1NameRow.textField.addTarget(self, action: #selector(owner1NameChanged), for: .editingChanged)
        owner1AddressRow.textField.addTarget(self, action: #selector(owner1AddressChanged), for: .editingChanged)
        owner1ContactsRow.textField.addTarget(self, action: #selector(owner1ContactsChanged), for: .editingChanged)
        
        owner2NameRow.textField.addTarget(self, action: #selector(owner2NameChanged), for: .editingChanged)
        owner2AddressRow.textField.addTarget(self, action: #selector(owner2AddressChanged), for: .editingChanged)
        owner2ContactsRow.textField.addTarget(self, action: #selector(owner2ContactsChanged), for: .editingChanged)
        
        owner3NameRow.textField.addTarget(self, action: #selector(owner3NameChanged), for: .editingChanged)
        owner3AddressRow.textField.addTarget(self, action: #selector(owner3AddressChanged), for: .editingChanged)
        owner3ContactsRow.textField.addTarget(self, action: #selector(owner3ContactsChanged), for: .editingChanged)
    }
}

// MARK: - Layout
private extension OwnersViewController {
    func setupViewsAndConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addSubview(bottomBarContainerView)
        scrollView.addSubview(contentContainerView)
        contentContainerView.addSubview(contentStackView)
        
        // Секции в стек
        contentStackView.addArrangedSubview(owner1TitleLabel)
        contentStackView.addArrangedSubview(owner1CardView)
        contentStackView.addArrangedSubview(owner2TitleLabel)
        contentStackView.addArrangedSubview(owner2CardView)
        contentStackView.addArrangedSubview(owner3TitleLabel)
        contentStackView.addArrangedSubview(owner3CardView)
        
        // Собираем карточки
        buildCard(owner1CardView, rows: [owner1NameRow, owner1AddressRow, owner1ContactsRow])
        buildCard(owner2CardView, rows: [owner2NameRow, owner2AddressRow, owner2ContactsRow])
        buildCard(owner3CardView, rows: [owner3NameRow, owner3AddressRow, owner3ContactsRow])
        
        // Кнопка Done
        bottomBarContainerView.addSubview(doneButton)
        let readable = bottomBarContainerView.readableContentGuide
        
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
}

// MARK: - Event Handler (Actions)
private extension OwnersViewController {
    @objc func closeTapped() {
        // Если внутри модальной навигации — закрываем её целиком
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func returnKeyDonePressed() {
        view.endEditing(true)
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
        delegate?.ownersViewController(self, didFinishWith: owners)
        navigationController?.popViewController(animated: true)
    }
    
    // Owner 1
    @objc func owner1NameChanged()    { owners[0].fullName = owner1NameRow.textField.text?.nilIfBlank }
    @objc func owner1AddressChanged() { owners[0].address = owner1AddressRow.textField.text?.nilIfBlank }
    @objc func owner1ContactsChanged(){ owners[0].contactDetails = owner1ContactsRow.textField.text?.nilIfBlank }
    
    // Owner 2
    @objc func owner2NameChanged()    { owners[1].fullName = owner2NameRow.textField.text?.nilIfBlank }
    @objc func owner2AddressChanged() { owners[1].address = owner2AddressRow.textField.text?.nilIfBlank }
    @objc func owner2ContactsChanged(){ owners[1].contactDetails = owner2ContactsRow.textField.text?.nilIfBlank }
    
    // Owner 3
    @objc func owner3NameChanged()    { owners[2].fullName = owner3NameRow.textField.text?.nilIfBlank }
    @objc func owner3AddressChanged() { owners[2].address = owner3AddressRow.textField.text?.nilIfBlank }
    @objc func owner3ContactsChanged(){ owners[2].contactDetails = owner3ContactsRow.textField.text?.nilIfBlank }
}
