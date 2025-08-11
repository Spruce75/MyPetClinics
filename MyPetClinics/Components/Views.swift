//
//  Views.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 30.6.2025.
//

import UIKit

enum ViewStyle {
    case view12Style
}

final class Views: UIView {
    
    init(style: ViewStyle) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: ViewStyle) {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .view12Style:
            backgroundColor = .systemBackground
            layer.cornerRadius = 12
        }
    }
}
