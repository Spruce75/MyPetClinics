//
//  MenuRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.7.2025.
//

import UIKit

final class MenuRow: UIControl {

    let titleText: String

    // Хранимые сабвью (на будущее, если понадобится менять стиль/иконку)
    private let titleLabel: Labels
    private let containerStackView: StackViews
    private var leadingIconView: UIImageView?

    // MARK: - Designated init (НОВЫЙ)
    init(
        title: String,
        labelStyle: LabelsStyle = .bold17LabelStyle,
        leadingSystemIconName: String? = nil,
        target: Any?,
        action: Selector
    ) {
        self.titleText = title
        self.titleLabel = Labels(style: labelStyle)
        self.containerStackView = StackViews(style: .containerStackView)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let target = target { addTarget(target, action: action, for: .touchUpInside) }

        titleLabel.text = title

        containerStackView.isUserInteractionEnabled = false
        containerStackView.alignment = .center   // ровное выравнивание по макету

        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.isUserInteractionEnabled = false

        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = .label
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(containerStackView)

        if let systemIcon = leadingSystemIconName {
            let iconView = UIImageView(image: UIImage(systemName: systemIcon))
            iconView.tintColor = .label
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.setContentHuggingPriority(.required, for: .horizontal)
            iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
            containerStackView.addArrangedSubview(iconView)
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 18),
                iconView.heightAnchor.constraint(equalToConstant: 18)
            ])
            self.leadingIconView = iconView
        }

        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(spacerView)
        containerStackView.addArrangedSubview(arrowImageView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Backward compatible init (КАК БЫЛО)
    convenience init(title: String, target: Any?, action: Selector) {
        self.init(
            title: title,
            labelStyle: .bold17LabelStyle,
            leadingSystemIconName: nil,
            target: target,
            action: action
        )
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
