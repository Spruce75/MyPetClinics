//
//  KeyValueRowView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 1.9.2025.
//

import UIKit

/// Универсальный ряд вида "Breed: British Shorthair". Скрывается, если `value` пустое.
final class KeyValueRowView: UIView {
    private let titleLabel = Labels(style: .sectionHeaderLabelStyle)
    private let valueLabel = Labels(style: .ordinaryText17LabelStyle)

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        addSubview(stack)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String, value: String?) {
        titleLabel.text = title
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        valueLabel.text = trimmed
        isHidden = (trimmed?.isEmpty ?? true)
    }
}
