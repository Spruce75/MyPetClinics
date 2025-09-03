//
//  ClinicPhotosCollectionViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.7.2025.
//

import UIKit

final class ClinicPhotosCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Properties
    static let reuseIdentifier = "ClinicPhotosCell"
    
    // MARK: - Private Properties
    private let imageView = Images(style: .thumbnail(name: ""))
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    func configure(with clinicPhoto: String?) {
        
        let placeholder = UIImage(named: "no photo")
        
        guard
            let name = clinicPhoto,
            let image = UIImage(named: name)
        else {
            imageView.image = placeholder
            return
        }
        imageView.image = image
    }
}

//MARK: - Layout
extension ClinicPhotosCollectionViewCell {
    private func setupViewsAndConstraints() {
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75)
        ])
    }
}
