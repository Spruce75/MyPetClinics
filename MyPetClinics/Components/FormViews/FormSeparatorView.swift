//
//  FormSeparatorView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import UIKit

final class FormSeparatorView: UIView {

    private let line = UIView()
    private let insets: UIEdgeInsets
    private let lineHeight: CGFloat

    /// Отступы по бокам и толщина линии. По умолчанию — 16pt слева/справа и 1px по высоте.
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
         lineHeight: CGFloat = 1.0 / UIScreen.main.scale) {
        self.insets = insets
        self.lineHeight = lineHeight
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        self.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.lineHeight = 1.0 / UIScreen.main.scale
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        backgroundColor = .clear

        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .separator
        addSubview(line)

        // фиксируем собственную высоту (чтобы stackView знал, сколько выделять места)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: lineHeight),

            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            line.topAnchor.constraint(equalTo: topAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
