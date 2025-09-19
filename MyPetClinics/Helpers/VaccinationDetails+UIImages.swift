//
//  VaccinationDetails+UIImages.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 19.9.2025.
//

// VaccinationDetails+UIImages.swift
import UIKit

extension VaccinationDetails {
    var uiImages: [UIImage] {
        if let imagesData, !imagesData.isEmpty {
            return imagesData.compactMap(UIImage.init(data:))
        }
        if let imageData, let image = UIImage(data: imageData) {
            return [image]
        }
        return []
    }
}

