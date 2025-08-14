//
//  Images.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.6.2025.
//

import UIKit

enum ImageStyle {
    case imageForBackground(name: String)
    case normal(name: String)
    case thumbnail(name: String)
    case largeProfile(name: String)
}

final class Images: UIImageView {
    
    init(style: ImageStyle) {
        super.init(image: nil)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: ImageStyle) {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .imageForBackground:
            contentMode = .scaleAspectFill
            clipsToBounds = true
            
        case .normal:
            contentMode = .scaleAspectFit
            widthAnchor.constraint(equalTo: heightAnchor).isActive = true
            
        case .thumbnail:
            contentMode = .scaleAspectFill
            clipsToBounds = true
            layer.cornerRadius = 8
            widthAnchor.constraint(equalTo: heightAnchor).isActive = true
            
        case .largeProfile:
            contentMode = .scaleAspectFit
            layer.cornerRadius = 8
            clipsToBounds = true
        }
        
        let imageName: String
        switch style {
        case .imageForBackground(let name),
             .normal(let name),
             .thumbnail(let name),
             .largeProfile(let name):
            imageName = name
        }
        
        image = UIImage(named: imageName)
             ?? UIImage(named: "no photo")
    }
}
