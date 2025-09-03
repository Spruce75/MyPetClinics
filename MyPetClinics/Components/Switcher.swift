//
//  Switcher.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 31.7.2025.
//

import UIKit

final class Switcher: UISwitch {

    init(target: Any?, action: Selector?) {
        super.init(frame: .zero)
        commonInit()
        
        if let target = target, let action = action {
            self.addTarget(target, action: action, for: .valueChanged)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.isOn = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.onTintColor = .blue
    }
}
