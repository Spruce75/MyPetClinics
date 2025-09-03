//
//  FormPickerTextFieldRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import UIKit

/// Ряд с выпадающим списком (UIPicker как inputView)
final class FormPickerTextFieldRow: FormTextFieldRow, UIPickerViewDelegate, UIPickerViewDataSource {

    private let picker = UIPickerView()
    private var options: [String] = []
    var onDidSelectIndex: ((Int) -> Void)?

    override init(placeholder: String) {
        super.init(placeholder: placeholder)

        picker.delegate = self
        picker.dataSource = self
        textField.inputView = picker

        // иконка-стрелка справа
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .tertiaryLabel
        addSubview(chevron)

        NSLayoutConstraint.activate([
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setOptions(_ options: [String], selectedIndex: Int? = nil) {
        self.options = options
        picker.reloadAllComponents()
        if let idx = selectedIndex, options.indices.contains(idx) {
            picker.selectRow(idx, inComponent: 0, animated: false)
            textField.text = options[idx]
        }
    }

    // MARK: - UIPickerViewDataSource/Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { options.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { options[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = options[row]
        onDidSelectIndex?(row)
    }
}
