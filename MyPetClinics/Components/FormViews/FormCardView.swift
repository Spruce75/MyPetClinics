//
//  FormCardView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import UIKit

/// Карточка формы (серый фон + скругление 12)
final class FormCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

