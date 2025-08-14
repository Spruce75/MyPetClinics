//
//  TabBarViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 4.6.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let clinicService: VetClinicService = PersistentVetClinicService()
    
    // MARK: - Private Properties
    private lazy var profileVC = createNavController(
        root: ProfileViewController(),
        titleKey: "profile_title",
        image: "profileNoActiveTabbar",
        selectedImage: "profileActiveTabbar"
    )

    private lazy var searchVC = createNavController(
        root: SearchViewController(clinicService: clinicService),
        titleKey: "search_title",
        image: "searchNoActiveTabbar",
        selectedImage: "searchActiveTabbar"
    )

    private lazy var myPetClinicsVC = createNavController(
        root: MyPetClinicsViewController(clinicService: clinicService),
        titleKey: "myPetClinics_title",
        image: "myPetClinicsNoActiveTabbar",
        selectedImage: "myPetClinicsActiveTabbar"
    )

    private lazy var appointmentsVC = createNavController(
        root: AppointmentsViewController(),
        titleKey: "appointments_title",
        image: "appointmentsNoActiveTabbar",
        selectedImage: "appointmentsActiveTabbar"
    )
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Private Functions
    private func createNavController(
        root: UIViewController,
        titleKey: String,
        image: String,
        selectedImage: String
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        
        let localizedTitle = String(localized: LocalizedStringResource(stringLiteral: titleKey))
        
        let tabBarItem = UITabBarItem(
            title: localizedTitle,
            image: UIImage(named: image),
            selectedImage: UIImage(named: selectedImage)
        )
        tabBarItem.accessibilityIdentifier = "\(titleKey)_tab"
        
        nav.tabBarItem = tabBarItem
        return nav
    }
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .black
            default:
                return .white
            }
        }

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        viewControllers = [profileVC, searchVC, myPetClinicsVC, appointmentsVC]
        selectedIndex = 1
    }
}
