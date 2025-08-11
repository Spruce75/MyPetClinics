//
//  ClinicRating.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.6.2025.
//

import UIKit

final class ClinicRating: UIStackView {
    
    // MARK: - Private Properties
    private let redStarsImage = Images(style: .normal(name: "redStarRating"))
    private let greyStarsImage = Images(style: .normal(name: "greyStarRating"))
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
    
    // MARK: - Public Methods
    func setupRating(rating: Int) {
        currentRating = max(0, min(rating, 5))
        
        for view in arrangedSubviews {
            if let imageView = view as? UIImageView {
                imageView.image = imageView.tag > currentRating
                ? greyStarsImage.image
                : redStarsImage.image
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupStackView() {
        axis = .horizontal
        spacing = 2
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    private func createStarImageView(tag: Int) -> UIImageView {
        let star = Images(style: .normal(name: "greyStarRating"))
        star.tag = tag
        return star
    }
    
    private func addStarImageViews(count: Int) {
        for index in 1...count {
            let starView = createStarImageView(tag: index)
            addArrangedSubview(starView)
        }
    }
}

