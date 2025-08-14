//
//  StaffViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 20.7.2025.
//

import UIKit

final class StaffViewController: UIViewController {
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
    
    private lazy var staffCollectionView: UICollectionView = {
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
            StaffCollectionViewCell.self,
            forCellWithReuseIdentifier: StaffCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private var staff: [StaffMember] = []

    // MARK: — Init
    init(clinic: VetClinic, screenTitle: String) {
        self.clinic = clinic
        self.staff = clinic.staff
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
        
        // Восстановление оригинального цвета Back кнопки
        if let original = originalTintColor {
            navigationController?.navigationBar.tintColor = original
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = staff.isEmpty
        staffCollectionView.isHidden = isEmpty
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
extension StaffViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        staff.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let member = staff[indexPath.item]
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StaffCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? StaffCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: member)
        return cell
    }
}

// MARK: — UICollectionViewDelegate
extension StaffViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let member = staff[indexPath.item]
        let detailVC = StaffDetailsViewController(member: member)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: — UICollectionViewDelegateFlowLayout
extension StaffViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let labelHeight: CGFloat = 40
        return CGSize(width: width, height: width + labelHeight)
    }
}

// MARK: — Layout
extension StaffViewController {
    private func setupViewsAndConstraints() {
        [placeholderImageView, staffCollectionView, clinicTitle, placeholderLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            clinicTitle.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            clinicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            staffCollectionView.topAnchor.constraint(
                equalTo: clinicTitle.bottomAnchor,
                constant: 16
            ),
            staffCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            staffCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            staffCollectionView.bottomAnchor.constraint(
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
