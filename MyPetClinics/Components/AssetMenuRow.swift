//
//  AssetMenuRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.9.2025.
//

import UIKit

/// Ряд меню с иконкой из ассетов (для Health Records).
final class AssetMenuRow: UIControl {

    let titleText: String

    private let titleLabel: Labels
    private let containerStackView: StackViews
    private let leadingImageView: UIImageView

    init(
        title: String,
        assetIconName: String,
        labelStyle: LabelsStyle = .ordinaryText17LabelStyle,
        target: Any?,
        action: Selector
    ) {
        self.titleText = title
        self.titleLabel = Labels(style: labelStyle)
        self.containerStackView = StackViews(style: .containerStackView)
        self.leadingImageView = UIImageView(image: UIImage(named: assetIconName))
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        if let target = target {
            addTarget(target, action: action, for: .touchUpInside)
        }

        titleLabel.text = title
        containerStackView.isUserInteractionEnabled = false
        containerStackView.alignment = .center

        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.setContentHuggingPriority(.required, for: .horizontal)
        leadingImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        leadingImageView.tintColor = .label

        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.isUserInteractionEnabled = false

        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.tintColor = .label
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(containerStackView)

        containerStackView.addArrangedSubview(leadingImageView)
        NSLayoutConstraint.activate([
            leadingImageView.widthAnchor.constraint(equalToConstant: 18),
            leadingImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

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

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
