//
//  TextViews.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 26.7.2025.
//

import UIKit

enum TextViewStyle {
    case descriptionTextStyle
}

final class TextViews: UITextView {

    // MARK: — Init
    init(style: TextViewStyle, text: String? = nil) {
        super.init(frame: .zero, textContainer: nil)
        commonInit(style: style)
        if let text = text {
            self.text = text
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: — Setup
    private func commonInit(style: TextViewStyle) {
        translatesAutoresizingMaskIntoConstraints = false
        isEditable = false
        isScrollEnabled = true
        showsVerticalScrollIndicator = true

        switch style {
        case .descriptionTextStyle:
            font = .systemFont(ofSize: 15)
            textColor = .label
            textContainerInset = .zero
            textContainer.lineFragmentPadding = 0
        }
    }
}
