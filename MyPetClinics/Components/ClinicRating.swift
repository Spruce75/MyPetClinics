//
//  ClinicRating.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.6.2025.
//

import UIKit

final class ClinicRating: UIStackView {
    
    // MARK: - Private Properties
    private lazy var redStarsImage: UIImage? = UIImage(named: "redStarRating")
    private lazy var greyStarsImage: UIImage? = UIImage(named: "greyStarRating")
    private var currentRating: Int = 0
    
    // MARK: - Initializers
    init(rating: Int = 5) {
        super.init(frame: .zero)
        setupStackView()
        addStarImageViews(count: 5)
        setupRating(rating: rating)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupStackView() {
        axis = .horizontal
        spacing = 2
        distribution = .fillProportionally
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createStarImageView(tag: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = greyStarsImage
        imageView.tag = tag
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.widthAnchor.constraint(
            equalTo: imageView.heightAnchor
        ).isActive = true
        
        return imageView
    }
    
    private func addStarImageViews(count: Int) {
        for index in 1...count {
            let imageView = createStarImageView(tag: index)
            addArrangedSubview(imageView)
        }
    }
    
    // MARK: - Public Methods
    func setupRating(rating: Int) {
        currentRating = max(0, min(rating, 5))
        
        for view in arrangedSubviews {
            if let imageView = view as? UIImageView {
                imageView.image = imageView.tag > currentRating
                ? greyStarsImage
                : redStarsImage
            }
        }
    }
}
