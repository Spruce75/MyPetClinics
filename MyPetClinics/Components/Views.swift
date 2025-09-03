//
//  Views.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 30.6.2025.
//

import UIKit

enum ViewStyle {
    case view12Style
    case view12Style2
    case notificationBadgeStyle
}

final class Views: UIView {

    private let currentStyle: ViewStyle

    init(style: ViewStyle) {
        self.currentStyle = style
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        switch currentStyle {
        case .view12Style:
            backgroundColor = .systemBackground
            layer.cornerRadius = 12

        case .view12Style2:
            backgroundColor = .secondarySystemBackground
            layer.masksToBounds = true
            
        case .notificationBadgeStyle:
            backgroundColor = .systemRed
            layer.masksToBounds = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        switch currentStyle {
            
        case .view12Style2:
            layer.cornerRadius = bounds.height / 2
            
        default:
            break
        }
    }
}
