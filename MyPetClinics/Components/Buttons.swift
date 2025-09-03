//
//  Buttons.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 1.7.2025.
//

import UIKit

enum ButtonsStyle {
    case actionButtonStyle(title: String, systemIconName: String)
    case toggleButtonStyle(systemIconName: String, selectedIconName: String)
    case socialNetworkStyle(iconName: String)
    case primary(title: String)
    case primary20(title: String)
    case primary20new(title: String)
}

final class Buttons: UIButton {
    
    private let currentStyle: ButtonsStyle
    
    init(
        style: ButtonsStyle,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        self.currentStyle = style
        super.init(frame: .zero)
        commonInit()
        
        if let target = target,
           let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupStyle()
    }
    
    private func setupStyle() {
        layer.cornerRadius = 12
        tintColor = .label
        setTitleColor(.label, for: .normal)
        
        switch currentStyle {
            
        case .actionButtonStyle(let title, let iconName):
            titleLabel?.font = .systemFont(ofSize: 17)
            setTitle(title, for: .normal)
            setImage(UIImage(systemName: iconName), for: .normal)
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            
        case .toggleButtonStyle(let normal, let selected):
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            let normalImage = UIImage(systemName: normal)?
                .withTintColor(.label, renderingMode: .alwaysOriginal)
            let selectedImage = UIImage(systemName: selected)?
                .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            
            setImage(normalImage, for: .normal)
            setImage(selectedImage, for: .selected)
            
        case .socialNetworkStyle(let iconName):
            guard let image = UIImage(named: iconName) else { return }
            setImage(image, for: .normal)
            imageView?.contentMode = .scaleAspectFit
            contentHorizontalAlignment = .fill
            contentVerticalAlignment = .fill
            
        case .primary(let title):
            titleLabel?.font = .boldSystemFont(ofSize: 17)
            setTitle(title, for: .normal)
            backgroundColor = .label
            setTitleColor(.systemBackground, for: .normal)
            heightAnchor.constraint(equalToConstant: 46).isActive = true
            
        case .primary20(let title):
            var configurationButton = UIButton.Configuration.filled()
            configurationButton.title = title
            configurationButton.baseBackgroundColor = .label
            configurationButton.baseForegroundColor = .systemBackground
            configurationButton.cornerStyle = .large
            configurationButton.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            configuration = configurationButton
            
        case .primary20new(let title):
            var configurationButton = UIButton.Configuration.filled()
            configurationButton.title = title
            configurationButton.baseBackgroundColor = .label
            configurationButton.baseForegroundColor = .systemBackground
            configurationButton.cornerStyle = .large
            configuration = configurationButton
            heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
    }
    
    func setBookmarked(_ bookmarked: Bool) {
        isSelected = bookmarked
    }
}
