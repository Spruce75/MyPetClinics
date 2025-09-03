//
//  PricesViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 17.7.2025.
//

import UIKit

final class PricesViewController: UIViewController {
    private let clinic: VetClinic
    private let screenTitle: String
    private let textView = TextViews(style: .descriptionTextStyle)
    private lazy var clinicTitle = Labels(style: .bold17LabelStyle, text: clinic.name)

    init(clinic: VetClinic, screenTitle: String) {
        self.clinic = clinic
        self.screenTitle = screenTitle
        super.init(nibName: nil, bundle: nil)
        title = screenTitle
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()

        configureTextView()
    }
    
    //MARK: - Private Methods
    private func configureTextView() {
        textView.text = clinic.pricesText
    }
}

//MARK: - Layout
extension PricesViewController {
    private func setupViewsAndConstraints() {
        
        [clinicTitle, textView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            clinicTitle.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            clinicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clinicTitle.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 16
            ),
            clinicTitle.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -16
            ),
            
            textView.topAnchor.constraint(
                equalTo: clinicTitle.bottomAnchor,
                constant: 12
            ),
            textView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            textView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            textView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
        ])
    }
}
