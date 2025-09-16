//
//  VaccinationsListViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 14.9.2025.
//

// VaccinationsListViewController.swift
//import UIKit
//
//final class VaccinationsListViewController: UIViewController {
//
//    // MARK: - Public
//    private let petDisplayName: String
//    private let petAvatarImageData: Data?
//    private let petAvatarFileName: String?
//    private let petId: UUID?
//
//    // MARK: - UI
//    private let scrollView = UIScrollView()
//    private let contentContainerView = UIView()
//    private let contentStackView = UIStackView()
//
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
//    private let sectionTitleLabel: Labels = {
//        let label = Labels(style: .ordinaryText17LabelStyle,
//                       text: String(localized: "vaccinations_title", defaultValue: "Vaccinations"))
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let listStackView = UIStackView()
//
//    // Пустое состояние
//    private let emptyStateContainerView = UIView()
//    private let emptyStateLabel: Labels = {
//        let label = Labels(style: .emptyStateTitleLabelStyle,
//                       text: String(localized: "no_vaccinations_title",
//                                    defaultValue: "No Vaccinations"))
//        return label
//    }()
//    private lazy var addVaccinationButton = Buttons(
//        style: .primary20new(title: String(localized: "add_vaccination_title", defaultValue: "Add vaccination")),
//        target: self,
//        action: #selector(addVaccinationTapped)
//    )
//
//    // MARK: - State
//    private var items: [VaccinationListItem] = []
//
//    // MARK: - Init
//    init(
//        petDisplayName: String,
//        petAvatarImageData: Data?,
//        petAvatarFileName: String?,
//        petId: UUID?
//    ) {
//        self.petDisplayName = petDisplayName
//        self.petAvatarImageData = petAvatarImageData
//        self.petAvatarFileName = petAvatarFileName
//        self.petId = petId
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
//        reloadFromStorage()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        reloadFromStorage()
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
//    private func fillHeader() {
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
//    private func reloadFromStorage() {
//        if let petId = petId {
//            items = VaccinationsStorage.shared.fetchVaccinations(forPetId: petId)
//        } else {
//            items = []
//        }
//        renderState()
//    }
//
//    private func renderState() {
//        listStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        let isEmpty = items.isEmpty
//        emptyStateContainerView.isHidden = !isEmpty
//        listStackView.isHidden = isEmpty
//
//        guard !isEmpty else { return }
//
//        for item in items {
//            let title = item.title?.nilIfBlank
//            ?? String(localized: "vaccination_default_title", defaultValue: "Vaccination")
//            let row = makeVaccinationRow(title: title)
//            row.accessibilityIdentifier = "vaccination_row_\(item.id.uuidString)"
//            listStackView.addArrangedSubview(row)
//        }
//    }
//
//    private func makeVaccinationRow(title: String) -> UIView {
//        let container = Views(style: .view12Style)
//        container.backgroundColor = .tertiarySystemFill
//
//        let label = Labels(style: .ordinaryText17LabelStyle, text: title)
//        container.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
//            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
//            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
//            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
//            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
//        ])
//        return container
//    }
//}
//
//// MARK: - Layout
//private extension VaccinationsListViewController {
//    func setupViewsAndConstraints() {
//        // Общая иерархия
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
//        contentStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentContainerView)
//        contentContainerView.addSubview(contentStackView)
//
//        // Контентный стек
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
//        // Секции
//        contentStackView.addArrangedSubview(headerContainerView)
//        contentStackView.addArrangedSubview(sectionTitleLabel)
//
//        // Пустое состояние (как в макете: заголовок, ниже кнопка)
//        emptyStateContainerView.translatesAutoresizingMaskIntoConstraints = false
//        emptyStateContainerView.addSubview(emptyStateLabel)
//        emptyStateContainerView.addSubview(addVaccinationButton)
//        contentStackView.addArrangedSubview(emptyStateContainerView)
//
//        // Список
//        listStackView.translatesAutoresizingMaskIntoConstraints = false
//        listStackView.axis = .vertical
//        listStackView.alignment = .fill
//        listStackView.spacing = 12
//        contentStackView.addArrangedSubview(listStackView)
//
//        // Констрейнты
//        NSLayoutConstraint.activate([
//            // Scroll
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            // Контейнер контента
//            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
//            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
//            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//
//            // Внутренний стек
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
//            // Пустое состояние
//            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateContainerView.centerXAnchor),
//            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateContainerView.topAnchor, constant: 80),
//
//            addVaccinationButton.centerXAnchor.constraint(equalTo: emptyStateContainerView.centerXAnchor),
//            addVaccinationButton.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 28),
//            addVaccinationButton.bottomAnchor.constraint(equalTo: emptyStateContainerView.bottomAnchor, constant: -40),
//            addVaccinationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
//        ])
//    }
//}
//
//// MARK: - Actions
//private extension VaccinationsListViewController {
//    @objc func closeTapped() {
//        if let nav = navigationController, nav.presentingViewController != nil {
//            nav.dismiss(animated: true)
//        } else if presentingViewController != nil {
//            dismiss(animated: true)
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//
//    @objc func addVaccinationTapped() {
//        let viewController = CreateNewVaccinationViewController(
//            petDisplayName: petDisplayName,
//            petAvatarImageData: petAvatarImageData,
//            petAvatarFileName: petAvatarFileName
//        )
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//}

import UIKit

final class VaccinationsListViewController: UIViewController, SortOptionsViewControllerDelegate {

    // MARK: - Public (header context)
    private let petDisplayName: String
    private let petAvatarImageData: Data?
    private let petAvatarFileName: String?
    private let petId: UUID?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    private let contentStackView = UIStackView()

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

    private let sectionTitleLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle,
                           text: String(localized: "vaccinations_title", defaultValue: "Vaccinations"))
        label.textAlignment = .center
        return label
    }()

    // Sort / Filter (как в Search)
    private let actionsStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .fill
        s.distribution = .fillEqually
        s.spacing = 12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private lazy var sortButton = Buttons(
        style: .actionButtonStyle(title: String(localized: "sort_title"), systemIconName: "arrow.up.arrow.down"),
        target: self, action: #selector(sortTapped)
    )
    private lazy var filterButton = Buttons(
        style: .actionButtonStyle(title: String(localized: "filter_title"), systemIconName: "slider.horizontal.3"),
        target: self, action: #selector(filterTapped)
    )

    private let listStackView = UIStackView()

    // Empty state
    private let emptyStateContainerView = UIView()
    private let emptyStateLabel: Labels = {
        let label = Labels(style: .emptyStateTitleLabelStyle,
                           text: String(localized: "no_vaccinations_title", defaultValue: "No Vaccinations"))
        return label
    }()
    private lazy var addVaccinationButton = Buttons(
        style: .primary20new(title: String(localized: "add_vaccination_title", defaultValue: "Add vaccination")),
        target: self, action: #selector(addVaccinationTapped)
    )

    // MARK: - State
    private var items: [VaccinationListItem] = []
    private let listDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yy"
        return f
    }()

    // Sort/Filter state
    private let sortOptions = [
        "Date (newest first)",
        "Date (oldest first)",
        "Title (A–Z)",
        "Title (Z–A)"
    ]
    private var selectedSortOptionIndex: Int?
    private var selectedFilterOptions: Set<String> = [] // пока не используем в фильтрации

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
        fillHeader()
        reloadFromStorage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFromStorage()
    }

    // MARK: - Setup
    private func setupNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain, target: self, action: #selector(closeTapped))
        closeButton.accessibilityLabel = String(localized: "close_title", defaultValue: "Close")
        navigationItem.rightBarButtonItem = closeButton
    }

    private func fillHeader() {
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

    private func reloadFromStorage() {
        if let petId {
            items = VaccinationsStorage.shared.fetchVaccinations(forPetId: petId)
        } else {
            items = []
        }
        applySelectedSort()
        renderState()
    }

    private func applySelectedSort() {
        guard let index = selectedSortOptionIndex else { return }
        switch index {
        case 0: // newest first
            items.sort { ($0.dateGiven ?? $0.createdAt) > ($1.dateGiven ?? $1.createdAt) }
        case 1: // oldest first
            items.sort { ($0.dateGiven ?? $0.createdAt) < ($1.dateGiven ?? $1.createdAt) }
        case 2: // title A–Z
            items.sort { ($0.title ?? "") < ($1.title ?? "") }
        case 3: // title Z–A
            items.sort { ($0.title ?? "") > ($1.title ?? "") }
        default: break
        }
    }

    private func renderState() {
        listStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let isEmpty = items.isEmpty
        emptyStateContainerView.isHidden = !isEmpty
        listStackView.isHidden = isEmpty
        actionsStackView.isHidden = isEmpty // как на макете, показываем когда есть список

        guard !isEmpty else { return }

        for (index, item) in items.enumerated() {
            let row = makeVaccinationRow(item: item, index: index)
            listStackView.addArrangedSubview(row)
        }
    }

    private func makeVaccinationRow(item: VaccinationListItem, index: Int) -> UIView {
        let container = Views(style: .view12Style)
        container.backgroundColor = .tertiarySystemGroupedBackground
        container.isUserInteractionEnabled = true
        container.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(rowTapped(_:)))
        container.addGestureRecognizer(tap)

        let dateLabel = Labels(style: .ordinaryText17LabelStyle,
                               text: item.dateGiven.map { listDateFormatter.string(from: $0) } ?? "")
        dateLabel.textAlignment = .left
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)

        let titleLabel = Labels(style: .ordinaryText17LabelStyle,
                                text: item.title ?? String(localized: "vaccination_default_title",
                                                           defaultValue: "Vaccination"))
        titleLabel.numberOfLines = 0

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 16
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(titleLabel)

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator

        container.addSubview(hStack)
        container.addSubview(separator)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -12),

            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    // MARK: - Sort delegate
    func sortOptionsViewController(_ controller: SortViewController, didSelectOptionAt index: Int) {
        selectedSortOptionIndex = index
        applySelectedSort()
        renderState()
    }
}

// MARK: - Layout
private extension VaccinationsListViewController {
    func setupViewsAndConstraints() {
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

        // Actions
        actionsStackView.addArrangedSubview(sortButton)
        actionsStackView.addArrangedSubview(filterButton)

        // Empty state
        emptyStateContainerView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateContainerView.addSubview(emptyStateLabel)
        emptyStateContainerView.addSubview(addVaccinationButton)

        // List stack
        listStackView.translatesAutoresizingMaskIntoConstraints = false
        listStackView.axis = .vertical
        listStackView.alignment = .fill
        listStackView.spacing = 0

        // Add to main stack
        contentStackView.addArrangedSubview(headerContainerView)
        contentStackView.addArrangedSubview(sectionTitleLabel)
        contentStackView.addArrangedSubview(actionsStackView)
        contentStackView.addArrangedSubview(emptyStateContainerView)
        contentStackView.addArrangedSubview(listStackView)

        NSLayoutConstraint.activate([
            // Scroll
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Content container
            contentContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // Inner stack
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

            // Actions height
            actionsStackView.heightAnchor.constraint(equalToConstant: 32),

            // Empty state
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateContainerView.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateContainerView.topAnchor, constant: 80),
            addVaccinationButton.centerXAnchor.constraint(equalTo: emptyStateContainerView.centerXAnchor),
            addVaccinationButton.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 28),
            addVaccinationButton.bottomAnchor.constraint(equalTo: emptyStateContainerView.bottomAnchor, constant: -40),
            addVaccinationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }
}

// MARK: - Actions
private extension VaccinationsListViewController {
    @objc func closeTapped() {
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func addVaccinationTapped() {
        let viewController = CreateNewVaccinationViewController(
            petDisplayName: petDisplayName,
            petAvatarImageData: petAvatarImageData,
            petAvatarFileName: petAvatarFileName,
            petId: petId
        )
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func sortTapped() {
        let sortVC = SortViewController()
        sortVC.options = sortOptions
        sortVC.selectedIndex = selectedSortOptionIndex
        sortVC.delegate = self
        if #available(iOS 15.0, *), let sheet = sortVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            let rowHeight: CGFloat = 44
            let rowsHeight = rowHeight * CGFloat(sortOptions.count)
            let topPadding: CGFloat = 12, titleHeight: CGFloat = 21, betweenTitleAndTable: CGFloat = 4
            let headerHeight = topPadding + titleHeight + betweenTitleAndTable
            let buttonHeight: CGFloat = 44, betweenTableAndButton: CGFloat = 4
            let bottomSafeArea = view.safeAreaInsets.bottom
            let footerHeight = buttonHeight + betweenTableAndButton + bottomSafeArea
            let total = headerHeight + rowsHeight + footerHeight
            sheet.detents = [.custom(identifier: .init("vaccinations.sort")) { _ in total }]
        }
        present(sortVC, animated: true)
    }

    @objc func filterTapped() {
        let filtersVC = FiltersViewController()
        filtersVC.setSelectedOptions(selectedFilterOptions)
        filtersVC.onFilterOptionsSave = { [weak self] options in
            // Фильтрацию добавим позже
            self?.selectedFilterOptions = options
        }
        if #available(iOS 15.0, *), let sheet = filtersVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.detents = [.large()]
        }
        present(filtersVC, animated: true)
    }

    @objc func rowTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag, index < items.count else { return }
        let item = items[index]
        // TODO: открыть экран деталей вакцинации (когда появится)
        print("Tapped vaccination:", item.id)
    }
}
