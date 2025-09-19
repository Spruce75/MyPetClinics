//
//  VaccinationTableViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 17.9.2025.
//

import UIKit

final class VaccinationTableViewCell: UITableViewCell {
    static let reuseIdentifier = "VaccinationTableViewCell"

    private let dateLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let titleLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        label.numberOfLines = 0
        return label
    }()

    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default

        contentView.addSubview(hStack)
        hStack.addArrangedSubview(dateLabel)
        hStack.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with item: VaccinationListItem, dateFormatter: DateFormatter) {
        dateLabel.text = item.dateGiven.map { dateFormatter.string(from: $0) } ?? ""
        titleLabel.text = item.title ?? String(localized: "vaccination_default_title", defaultValue: "Vaccination")
    }
}
