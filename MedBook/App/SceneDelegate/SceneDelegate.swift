//
//  SceneDelegate.swift
//  MedBook
//
//  Created by Sanath on 08/04/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let viewController = getRootViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Private methods

private extension SceneDelegate {
    func getRootViewController() -> UIViewController {
        if UserDefaults.standard.fetchIsLoggedIn() {
            let viewController = HomeBuilder().build()
            return viewController
        } else {
            let viewController = LandingBuilder().build()
            return viewController
        }
    }
}

