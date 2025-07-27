//
//  StaffDetailViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 20.7.2025.
//

import UIKit

final class StaffDetailsViewController: UIViewController {
    // MARK: - Private Properties
    private let member: StaffMember
    private let nameLabel = Labels(style: .bold17LabelStyle)
    private lazy var imageView = Images(
        style: .largeProfile(name: member.imageName)
    )
    
    // MARK: - Initializers
    init(member: StaffMember) {
        self.member = member
        super.init(nibName: nil, bundle: nil)
        title = member.name
        nameLabel.text = member.name
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()
    }
}

//MARK: - Layout
extension StaffDetailsViewController {
    private func setupViewsAndConstraints() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor
            ),
            
            nameLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 16
            ),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
}

