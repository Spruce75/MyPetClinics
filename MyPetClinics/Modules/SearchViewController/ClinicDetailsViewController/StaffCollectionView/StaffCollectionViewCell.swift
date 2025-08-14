//
//  StaffCollectionViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 20.7.2025.
//

import UIKit

final class StaffCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Properties
    static let reuseIdentifier = "StaffCell"
    
    // MARK: - Private Properties
    private let imageView = Images(style: .thumbnail(name: ""))
    private let nameLabel = Labels(style: .ordinaryText13LabelStyle)
    private let stack = StackViews(style: .verticalCenterStackView)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    func configure(with member: StaffMember) {
        nameLabel.text  = member.name
        
        let placeholder = UIImage(named: "no photo")
        imageView.image = UIImage(named: member.imageName) ?? placeholder
    }
}

//MARK: - Layout
extension StaffCollectionViewCell {
    private func setupViewsAndConstraints() {
        
        contentView.addSubview(stack)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: stack.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

