//
//  SearchResultTableViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.6.2025.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = "SearchResultCell"
    
    // MARK: - Private Properties
    private var bookmarkAction: UIAction?
    
    private lazy var bookmarkButton = Buttons(
        style: .toggleButtonStyle(
            systemIconName: "bookmark",
            selectedIconName: "bookmark.fill"
        )
    )
    
    private let titleLabel = Labels(style: .bold17LabelStyle)
    private let addressLabel = Labels(style: .ordinaryText13LabelStyle)
    private let cityCountryLabel = Labels(style: .ordinaryText13LabelStyle)
    private let websiteLabel = Labels(style: .ordinaryText13LabelStyle)
    private let phoneLabel = Labels(style: .ordinaryText13LabelStyle)
    private let emailLabel = Labels(style: .ordinaryText13LabelStyle)
    private let emergencyLabel = Labels(style: .ordinaryText13RedLabelStyle)
    
    private let clinicRatingImage = ClinicRating()
    
    private let clinicBriefStackView = StackViews(style: .vertical4StackView)
    private let ratingAndBookmarkStackView = StackViews(style: .horizontal8StackView)
    private let conteinerStackView = StackViews(style: .containerStackView)
    
    private let cardView = Views(style: .view12Style)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with clinic: VetClinic,onBookmarkToggle: @escaping (VetClinic) -> ()) {
        titleLabel.text = clinic.name
        addressLabel.text = "\(clinic.address), \(clinic.postalCode)"
        cityCountryLabel.text = "\(clinic.city), \(clinic.country)"
        websiteLabel.text = clinic.websiteURL.absoluteString
        phoneLabel.text = "📞 " + clinic.phoneNumber
        emailLabel.text = clinic.email
        emergencyLabel.text = clinic.emergencyInfo
        
        clinicRatingImage.setupRating(rating: clinic.rating)
        
        bookmarkButton.setBookmarked(clinic.isBookmarked)
        configureBookmarkAction(
            for: clinic,
            onToggle: onBookmarkToggle
        )
    }
    
    // MARK: - Private Methods
    private func configureBookmarkAction(
        for clinic: VetClinic,
        onToggle: @escaping (VetClinic) -> ()
    ) {
        if let old = bookmarkAction {
            bookmarkButton.removeAction(old, for: .touchUpInside)
        }
        let action = UIAction { [weak bookmarkButton] _ in
            guard let btn = bookmarkButton else { return }
            btn.isSelected.toggle()
            var updated = clinic
            updated.isBookmarked = btn.isSelected
            onToggle(updated)
        }
        bookmarkButton.addAction(action, for: .touchUpInside)
        bookmarkAction = action
    }
}

//MARK: - Layout
extension SearchResultTableViewCell {
    private func setupViewsAndConstraints() {
        
        [cardView].forEach {
            contentView.addSubview($0)
        }
        
        [conteinerStackView].forEach {
            cardView.addSubview($0)
        }
        
        [clinicBriefStackView, ratingAndBookmarkStackView].forEach {
            conteinerStackView.addArrangedSubview($0)
        }
        
        [titleLabel, cityCountryLabel, addressLabel, websiteLabel, phoneLabel, emailLabel, emergencyLabel].forEach {
            clinicBriefStackView.addArrangedSubview($0)
        }
        
        [clinicRatingImage, bookmarkButton].forEach {
            ratingAndBookmarkStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,  constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            conteinerStackView.topAnchor.constraint(equalTo: cardView.topAnchor,    constant: 12),
            conteinerStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,  constant: 12),
            conteinerStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            conteinerStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            
            clinicRatingImage.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
