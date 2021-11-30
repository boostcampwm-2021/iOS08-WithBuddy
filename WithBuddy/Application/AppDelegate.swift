//
//  AppDelegate.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return UIInterfaceOrientationMask.portrait
   }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window,
              let id = UUID(uuidString: response.notification.request.identifier) else { return }
        
        let tabBarController = TabBarViewController()
        tabBarController.selectedIndex = 3
        let navigationController = UINavigationController(rootViewController: tabBarController)
        let gatheringDetailViewController = GatheringDetailViewController()
        gatheringDetailViewController.id = id
        navigationController.pushViewController(gatheringDetailViewController, animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        completionHandler()
    }

}

