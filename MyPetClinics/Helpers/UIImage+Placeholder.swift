//
//  UIImage+Placeholder.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.7.2025.
//

import UIKit

extension UIImage {
    static func loadOrPlaceholder(
        named name: String,
        in traitCollection: UITraitCollection
    ) -> UIImage? {
        if let img = UIImage(named: name) { return img }
        let placeholderName = traitCollection.userInterfaceStyle == .dark
        ? "no photo dark mode"
        : "no photo light mode"
        return UIImage(named: placeholderName)
    }
}
