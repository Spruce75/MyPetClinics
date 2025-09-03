//
//  StaffDetailViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 20.7.2025.
//

import UIKit

final class StaffDetailsViewController: UIViewController {
    // MARK: - Private Properties
    private let staffMember: StaffMember
    private let nameLabel = Labels(style: .bold17LabelStyle)
    private let staffBioTextView = TextViews(style: .descriptionTextStyle)
    private lazy var imageView = Images(
        style: .largeProfile(name: staffMember.imageName)
    )
    
    // MARK: - Initializers
    init(member: StaffMember) {
        self.staffMember = member
        super.init(nibName: nil, bundle: nil)
        title = member.name
        nameLabel.text = member.name
        staffBioTextView.text = member.bio
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
        
        [imageView, nameLabel, staffBioTextView].forEach {
            view.addSubview($0)
        }
        
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
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            staffBioTextView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 12
            ),
            staffBioTextView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            staffBioTextView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            staffBioTextView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            )
        ])
        
    }
}
