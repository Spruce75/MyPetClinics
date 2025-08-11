//
//  StackViews.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.6.2025.
//

import UIKit

enum StackViewStyle {
    case vertical4StackView
    case horizontal8StackView
    case horizontal6StackView
    case verticall6StackView
    case containerStackView
    case verticall6StackView2
    case verticalCenterStackView
}

final class StackViews: UIStackView {

    // MARK: - Initializers
    init(style: StackViewStyle) {
        super.init(frame: .zero)
        commonInit(style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - StackView cases
    private func commonInit(style: StackViewStyle) {
        switch style {
        case .vertical4StackView:
            axis = .vertical
            spacing = 4
            alignment = .leading
            distribution = .equalSpacing
            
        case .horizontal8StackView:
            axis = .horizontal
            spacing = 8
            alignment = .center
            distribution = .fill
            
        case .horizontal6StackView:
            axis = .horizontal
            spacing = 16
            alignment = .center
            distribution = .fillEqually
            
        case .verticall6StackView:
            axis = .vertical
            spacing = 16
            alignment = .center
            distribution = .equalSpacing
            
        case .verticall6StackView2:
            axis = .vertical
            spacing = 16
            
        case .containerStackView:
            axis = .horizontal
            spacing = 12
            alignment = .top
            
        case .verticalCenterStackView:
            axis = .vertical
            spacing = 8
            alignment = .center
            distribution = .fill
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

