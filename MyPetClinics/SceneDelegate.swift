//
//  SceneDelegate.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 3.6.2025.
//

//import UIKit
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        let dynamicBackButtonColor: UIColor = {
//            if #available(iOS 13.0, *) {
//                return UIColor { traitCollection in
//                    traitCollection.userInterfaceStyle == .dark ? .white : .black
//                }
//            } else {
//                return .black
//            }
//        }()
//        UINavigationBar.appearance().tintColor = dynamicBackButtonColor
//        
//        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = TabBarViewController()
//        window?.makeKeyAndVisible()
//    }
//}

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Цвет стрелки "Назад"
        let dynamicBackButtonColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
            } else {
                return .black
            }
        }()
        UINavigationBar.appearance().tintColor = dynamicBackButtonColor

        // ВАЖНО: сначала rootViewController, потом makeKeyAndVisible
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        window.rootViewController = TabBarViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}


