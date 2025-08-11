//
//  SceneDelegate.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 3.6.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let dynamicBackButtonColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollection in
                    traitCollection.userInterfaceStyle == .dark ? .white : .black
                }
            } else {
                return .black
            }
        }()
        UINavigationBar.appearance().tintColor = dynamicBackButtonColor
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarViewController()
    }
}

