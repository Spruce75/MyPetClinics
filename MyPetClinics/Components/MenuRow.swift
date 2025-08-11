//
//  MenuRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.7.2025.
//

import UIKit

final class MenuRow: UIControl {
    
    let titleText: String
    
    // MARK: - Init
    init(title: String, target: Any?, action: Selector) {
        self.titleText = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addTarget(target, action: action, for: .touchUpInside)
        
        let label = Labels(style: .bold17LabelStyle)
        label.text = title
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.isUserInteractionEnabled = false
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .label
        
        let stack = StackViews(style: .containerStackView)
        stack.isUserInteractionEnabled = false
        
        addSubview(stack)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(arrow)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

