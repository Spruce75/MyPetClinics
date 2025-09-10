//
//  PetTableViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 18.8.2025.
//

import UIKit

final class PetTableViewCell: UITableViewCell {
    
    // MARK: - Static
    static let reuseIdentifier = "PetTableViewCell"
    
    // MARK: - UI
    private let avatarImageView = Images(style: .imageForBackground(name: "no photo"))
    private let nameLabel = Labels(style: .bold34TitleLabelStyle)
    private let notificationBadgeView = Views(style: .notificationBadgeStyle)
    private let notificationBadgeLabel = Labels(style: .badgeCountLabelStyle)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        selectionStyle = .default
        setupViewsAndConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        notificationBadgeLabel.text = nil
        notificationBadgeView.isHidden = true
    }
    
    // MARK: - Configure
    func configure(with pet: Pet, traitCollection: UITraitCollection) {
        nameLabel.text = pet.name
        avatarImageView.image = UIImage.loadOrPlaceholder(named: pet.imageName, in: traitCollection)
        
        let count = pet.unreadNotificationsCount
        if count > 0 {
            notificationBadgeLabel.text = (count > 9) ? "9+" : "\(count)"
            notificationBadgeView.isHidden = false
        } else {
            notificationBadgeView.isHidden = true
        }
        
        if let data = pet.avatarImageData, let image = UIImage(data: data) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage.loadOrPlaceholder(named: pet.imageName, in: traitCollection)
        }
        
    }
}

// MARK: - Layout
private extension PetTableViewCell {
    func setupViewsAndConstraints() {
        contentView.addSubview(avatarImageView)
        
        let avatarSize: CGFloat = 112
        let badgeHeight: CGFloat = 28
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarSize / 2
        
        contentView.addSubview(notificationBadgeView)
        notificationBadgeView.addSubview(notificationBadgeLabel)
        
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize),
            
            notificationBadgeView.heightAnchor.constraint(equalToConstant: badgeHeight),
            notificationBadgeView.widthAnchor.constraint(equalTo: notificationBadgeView.heightAnchor),
            
            notificationBadgeView.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: -5),
            notificationBadgeView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -25),
            
            notificationBadgeLabel.centerXAnchor.constraint(equalTo: notificationBadgeView.centerXAnchor),
            notificationBadgeLabel.centerYAnchor.constraint(equalTo: notificationBadgeView.centerYAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
        
        notificationBadgeView.layer.cornerRadius = badgeHeight / 2
    }
}
