//
//  ClinicPhotosViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 27.7.2025.
//

import UIKit

final class ClinicPhotosViewController: UIViewController {
    // MARK: — Private Properties
    private let screenTitle: String
    private let clinic: VetClinic
    private let clinicTitle = Labels(style: .bold17LabelStyle)
    private var originalTintColor: UIColor?
    
    private let placeholderImageView = Images(
        style: .imageForBackground(name: "dogNothingFound")
    )
    
    private let placeholderLabel: Labels = {
        let label = Labels(style: .stubLabelStyle)
        label.text = "Nothing found"
        label.isHidden = true
        return label
    }()
    
    private lazy var clinicPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            ClinicPhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: ClinicPhotosCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private var clinicPhotos: [String] = []

    // MARK: — Init
    init(clinic: VetClinic, screenTitle: String) {
        self.clinic = clinic
        self.clinicPhotos = clinic.clinicPhotos ?? []
        self.screenTitle = screenTitle
        super.init(nibName: nil, bundle: nil)

        title = screenTitle
        clinicTitle.text = clinic.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: — Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViewsAndConstraints()
        updateEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateEmptyState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let original = originalTintColor {
            navigationController?.navigationBar.tintColor = original
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = clinicPhotos.isEmpty
        clinicPhotosCollectionView.isHidden = isEmpty
        placeholderImageView.isHidden = !isEmpty
        placeholderLabel.isHidden = !isEmpty
        clinicTitle.textColor = isEmpty ? .white : .label
        
        let appearance = UINavigationBarAppearance()
        if isEmpty {
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.barStyle = .black
        } else {
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navigationController?.navigationBar.barStyle = .default
        }
        
        if #available(iOS 15.0, *) {
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        if isEmpty {
            if originalTintColor == nil {
                originalTintColor = navigationController?.navigationBar.tintColor
            }
            navigationController?.navigationBar.tintColor = .white
        } else {
            if let original = originalTintColor {
                navigationController?.navigationBar.tintColor = original
            }
        }
    }
}

// MARK: — UICollectionViewDataSource
extension ClinicPhotosViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        clinicPhotos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ClinicPhotosCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ClinicPhotosCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let photoName = clinicPhotos[indexPath.item]
        cell.configure(with: photoName)
        return cell
    }
}

// MARK: — UICollectionViewDelegateFlowLayout
extension ClinicPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 16
        let width = collectionView.bounds.width - (spacing * 2)
        let height = width * 0.75
        return CGSize(width: width, height: height)
    }
}

// MARK: — Layout
extension ClinicPhotosViewController {
    private func setupViewsAndConstraints() {
        [placeholderImageView, clinicPhotosCollectionView, clinicTitle, placeholderLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            clinicTitle.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            clinicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clinicPhotosCollectionView.topAnchor.constraint(
                equalTo: clinicTitle.bottomAnchor,
                constant: 16
            ),
            clinicPhotosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            clinicPhotosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clinicPhotosCollectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            
            placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            NSLayoutConstraint(
                item: placeholderLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 0.20,
                constant: 0
            ),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
