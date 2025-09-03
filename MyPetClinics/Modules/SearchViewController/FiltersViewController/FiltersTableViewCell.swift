//
//  FiltersTableViewCell.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 31.7.2025.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    
    //MARK: - Static Properties
    static let reuseIdentifier = "FilterOptionCell"
    
    //MARK: - Public Properties
    var switchValueChanged: ((String, Bool) -> Void)?
    var filterOption: String?
    
    //MARK: - Private Properties
    
    private lazy var switcher: Switcher = {
        let switcher = Switcher(
            target: self,
            action: #selector(switcherClicked)
        )
        return switcher
    }()
    
    private lazy var infoButton = Buttons(
        style: .actionButtonStyle(
            title: "",
            systemIconName: "info.circle"
        )
    )
    
    private let cellHeight: CGFloat = 75
    
    private let optionLabel: Labels = {
        let label = Labels(style: .ordinaryText17LabelStyle)
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        clipsToBounds = true

        setupViewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Implement this method
    override func prepareForReuse() {
        super.prepareForReuse()
        switchValueChanged = nil
        filterOption = nil
        optionLabel.text = nil
        switcher.setOn(false, animated: false)
    }

    // MARK: - Public functions
    func configure(text: String, isOn: Bool) {
        optionLabel.text = text
        switcher.setOn(isOn, animated: false)
        self.filterOption = text
    }
    
    //MARK: - Event Handler (Actions)
    @objc private func switcherClicked(_ sender: UISwitch) {
        guard let filterOption = self.filterOption else { return }
        switchValueChanged?(filterOption, sender.isOn)
    }
}

//MARK: - Layout
extension FilterTableViewCell {
    private func setupViewsAndConstraints() {
        
        [optionLabel, infoButton, switcher].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            infoButton.trailingAnchor.constraint(equalTo: switcher.leadingAnchor, constant: -20),
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }
}
