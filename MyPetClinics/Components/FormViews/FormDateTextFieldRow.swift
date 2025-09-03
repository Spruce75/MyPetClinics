//
//  FormDateTextFieldRow.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.8.2025.
//

import UIKit

/// Ряд с UIDatePicker (дата рождения)
final class FormDateTextFieldRow: FormTextFieldRow {

    private let datePicker = UIDatePicker()
    var onDidPickDate: ((Date) -> Void)?

    override init(placeholder: String) {
        super.init(placeholder: placeholder)

        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.datePickerMode = .date
        textField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        ]
        textField.inputAccessoryView = toolbar

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func dateChanged() { updateTextAndNotify() }
    @objc private func doneTapped()  { updateTextAndNotify(); textField.resignFirstResponder() }
    @objc private func cancelTapped(){ textField.resignFirstResponder() }

    private func updateTextAndNotify() {
        let f = DateFormatter()
        f.dateStyle = .long
        textField.text = f.string(from: datePicker.date)
        onDidPickDate?(datePicker.date)
    }
}
