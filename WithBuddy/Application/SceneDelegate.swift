//
//  SceneDelegate.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        _ = CoreDataManager.shared
        window = UIWindow(windowScene: windowScene)
        if let _ = UserUseCase().fetchUser() {
            let tabBarViewController = TabBarViewController()
            window?.rootViewController = UINavigationController(rootViewController: tabBarViewController)
            tabBarViewController.configureLoading()
        } else {
            let userCreateViewController = UserCreateViewController()
            window?.rootViewController = UINavigationController(rootViewController: userCreateViewController)
            userCreateViewController.configureLoading()
        }
        window?.makeKeyAndVisible()
    }
    
}

