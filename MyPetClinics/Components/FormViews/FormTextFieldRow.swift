//
//  FormTextFieldRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import UIKit

/// Базовый ряд формы с текстовым полем
class FormTextFieldRow: UIView {

    let textField = UITextField()

    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.textColor = .label
        textField.tintColor = .systemBlue
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done

        addSubview(textField)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 52),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
