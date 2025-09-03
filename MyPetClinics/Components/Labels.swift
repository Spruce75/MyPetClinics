//
//  Labels.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.6.2025.
//

import UIKit

enum LabelsStyle {
    case stubLabelStyle
    case bold17LabelStyle
    case ordinaryText13LabelStyle
    case ordinaryText13LabelStyle2
    case ordinaryText13RedLabelStyle
    case bold20LabelStyle
    case ordinaryText17LabelStyle
    case sectionHeaderLabelStyle
    case bold34TitleLabelStyle
    case badgeCountLabelStyle
}

final class Labels: UILabel {
    
    init(style: LabelsStyle, text: String? = nil) {
        super.init(frame: .zero)
        commonInit(style: style)
        
        if let text = text {
            self.text = text
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(style: LabelsStyle) {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .stubLabelStyle:
            font = UIFont.systemFont(ofSize: 34, weight: .bold)
            numberOfLines = 1
            textAlignment = .center
            textColor = .dynamicLabelColor
            
        case .bold17LabelStyle:
            font = UIFont.boldSystemFont(ofSize: 17)
            textColor = .label
            
        case .ordinaryText17LabelStyle:
            font = UIFont.systemFont(ofSize: 17, weight: .regular)
            textColor = .label
            
        case .bold20LabelStyle:
            font = UIFont.boldSystemFont(ofSize: 20)
            textColor = .label
            
        case .ordinaryText13LabelStyle:
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            textColor = .label
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
            
        case .ordinaryText13LabelStyle2:
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            textColor = .label
            numberOfLines = 2
            lineBreakMode = .byWordWrapping
            textAlignment = .center
            
        case .ordinaryText13RedLabelStyle:
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            textColor = .systemRed
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
            
        case .sectionHeaderLabelStyle:
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
            textColor = .secondaryLabel
            numberOfLines = 1
            
        case .bold34TitleLabelStyle:
            font = UIFont.boldSystemFont(ofSize: 34)
            textColor = .label
            textAlignment = .left
            numberOfLines = 1
            
        case .badgeCountLabelStyle:
            font = UIFont.boldSystemFont(ofSize: 12)
            textColor = .white
            textAlignment = .center
            numberOfLines = 1
        }
    }
}
