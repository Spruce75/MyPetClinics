//
//  ClinicDetailsViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 9.7.2025.
//

import UIKit
import SafariServices

final class ClinicDetailsViewController: UIViewController {
    
    //MARK: - Private Properties
    private let buttonSizeMultiplier: CGFloat = 0.10
    
    private var clinic: VetClinic
    private let clinicService: VetClinicService
    private let onBookmarkToggle: (VetClinic) -> Void
    
    private lazy var bookmarkButton = Buttons(
        style: .toggleButtonStyle(
            systemIconName: "bookmark",
            selectedIconName: "bookmark.fill"
        )
    )
    private var bookmarkAction: UIAction?
    
    private let titleLabel = Labels(style: .bold17LabelStyle)
    private let addressLabel = Labels(style: .ordinaryText13LabelStyle)
    private let cityCountryLabel = Labels(style: .ordinaryText13LabelStyle)
    private let websiteLabel = Labels(style: .ordinaryText13LabelStyle)
    private let phoneLabel = Labels(style: .ordinaryText13LabelStyle)
    private let emailLabel = Labels(style: .ordinaryText13LabelStyle)
    private let emergencyLabel = Labels(style: .ordinaryText13RedLabelStyle)
    
    private lazy var instagramButton = Buttons(
        style: .socialNetworkStyle(iconName: "instagram"),
        target: self,
        action: #selector(instagramTapped)
    )
    private lazy var facebookButton = Buttons(
        style: .socialNetworkStyle(iconName: "facebook"),
        target: self,
        action: #selector(facebookTapped)
    )
    
    private let clinicBriefStackView = StackViews(style: .vertical4StackView)
    private lazy var socialStackView = StackViews(style: .verticall6StackView)
    private lazy var mainStackView = StackViews(style: .containerStackView)
    
    private let clinicRatingImage = ClinicRating()
    private let descriptionLabel = Labels(style: .ordinaryText13RedLabelStyle)
    
    private lazy var menuStackView = StackViews(style: .verticall6StackView2)
    
    private lazy var pricesRow = MenuRow(
        title: String(localized: "prices_title"),
        target: self,
        action: #selector(pricesTapped)
    )
    private lazy var staffRow  = MenuRow(
        title: String(localized: "staff_title"),
        target: self,
        action: #selector(staffTapped)
    )
    private lazy var photosRow = MenuRow(
        title: String(localized: "photos_title"),
        target: self,
        action: #selector(photosTapped)
    )
    
    private lazy var bookingButton = Buttons(
        style: .primary(title: "Online booking"),
        target: self,
        action: #selector(bookingTapped)
    )
    
    // MARK: - Init
    init(
        clinic: VetClinic,
        clinicService: VetClinicService,
        onBookmarkToggle: @escaping (VetClinic) -> ()
    ) {
        self.clinic = clinic
        self.clinicService = clinicService
        self.onBookmarkToggle = onBookmarkToggle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDescriptionLabel()
        setupClinicBrief()
        setupViewsAndConstraints()
        
        bookmarkButton.setBookmarked(clinic.isBookmarked)
        configureBookmarkAction()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        
        clinicRatingImage.setupRating(rating: clinic.rating)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBookmarksChanged),
            name: .vetClinicBookmarksDidChange,
            object: nil
        )
    }
    
    // MARK: - Private functions
    
    private func configureBookmarkAction() {
        if let old = bookmarkAction {
            bookmarkButton.removeAction(old, for: .touchUpInside)
        }
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.clinic.isBookmarked.toggle()
            self.bookmarkButton.setBookmarked(self.clinic.isBookmarked)
            self.clinicService.updateBookmark(
                self.clinic,
                isBookmarked: self.clinic.isBookmarked
            ) { }
            self.onBookmarkToggle(self.clinic)
        }
        bookmarkButton.addAction(action, for: .touchUpInside)
        bookmarkAction = action
    }
    
    private func setupClinicBrief() {
        titleLabel.text = clinic.name
        addressLabel.text = "\(clinic.address), \(clinic.postalCode)"
        cityCountryLabel.text = "\(clinic.city), \(clinic.country)"
        websiteLabel.text = clinic.websiteURL.absoluteString
        phoneLabel.text = "📞 " + clinic.phoneNumber
        emailLabel.text = clinic.email
        emergencyLabel.text = clinic.emergencyInfo
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = clinic.description
    }
    
    // MARK: - Event Handler (Actions)
    @objc private func handleBookmarksChanged() {
        clinicService.fetchClinics { [weak self] clinics in
            guard let self = self else { return }
            if let fresh = clinics.first(where: { $0.id == self.clinic.id }) {
                DispatchQueue.main.async {
                    self.clinic = fresh
                    self.bookmarkButton.setBookmarked(fresh.isBookmarked)
                }
            }
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func instagramTapped() {
        guard let url = clinic.instagramURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func facebookTapped() {
        guard let url = clinic.facebookURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func pricesTapped() {
        let screenTitle = pricesRow.titleText
        let viewController = PricesViewController(
            clinic: clinic,
            screenTitle: screenTitle
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func staffTapped() {
        let screenTitle = staffRow.titleText
        let viewController = StaffViewController(
            clinic: clinic,
            screenTitle: screenTitle
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func photosTapped() {
        let screenTitle = photosRow.titleText
        let viewController = ClinicPhotosViewController(
            clinic: clinic,
            screenTitle: screenTitle
        )
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func bookingTapped() {
        
    }
}

// MARK: - Layout
extension ClinicDetailsViewController {
    private func setupViewsAndConstraints() {
        
        [mainStackView, clinicRatingImage, descriptionLabel, menuStackView, bookingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [clinicBriefStackView, socialStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [titleLabel, cityCountryLabel, addressLabel, websiteLabel, phoneLabel, emailLabel, emergencyLabel].forEach {
            clinicBriefStackView.addArrangedSubview($0)
        }
        
        [instagramButton, facebookButton].forEach {
            socialStackView.addArrangedSubview($0)
        }
        
        [pricesRow, staffRow, photosRow].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            menuStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            instagramButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonSizeMultiplier),
            instagramButton.heightAnchor.constraint(equalTo: instagramButton.widthAnchor),

            facebookButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonSizeMultiplier),
            facebookButton.heightAnchor.constraint(equalTo: facebookButton.widthAnchor),
            
            mainStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            
            clinicRatingImage.topAnchor.constraint(
                equalTo: mainStackView.bottomAnchor,
                constant: 24
            ),
            clinicRatingImage.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: clinicRatingImage.bottomAnchor,
                constant: 24
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            
            menuStackView.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 24
            ),
            menuStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            menuStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            
            bookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookingButton.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.5
            ),
            bookingButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            bookingButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
