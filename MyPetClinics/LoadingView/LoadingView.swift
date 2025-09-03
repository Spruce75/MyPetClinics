//
//  LoadingView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 2.7.2025.
//

import UIKit

final class LoadingView: UIView {
    
    // MARK: - Subviews
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .label
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private functions
    private func commonInit() {
        backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(white: 0, alpha: 0.3)
            default:
                return UIColor(white: 1, alpha: 0.6)
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    // MARK: - Public functions
    func show() {
        isHidden = false
        superview?.bringSubviewToFront(self)
        activityIndicator.startAnimating()

        print("LoadingView show")

    }
    
    func hide() {
        activityIndicator.stopAnimating()
        isHidden = true

        print("LoadingView hide")

    }
}

