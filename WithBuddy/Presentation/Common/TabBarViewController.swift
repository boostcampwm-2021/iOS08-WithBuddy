//
//  TabbarViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        let calendar = configureTab(controller: RegisterViewController(), title: "일정", photoName: "calendar")
        let chart = configureTab(controller: RegisterViewController(), title: "통계", photoName: "chart.bar.xaxis")
        let register = configureTab(controller: RegisterViewController(), title: "모임등록", photoName: "person.3.fill")
        let list = configureTab(controller: RegisterViewController(), title: "목록", photoName: "list.bullet.rectangle.fill")
        let setting = configureTab(controller: RegisterViewController(), title: "설정", photoName: "gearshape.fill")
        self.viewControllers = [calendar, chart, register, list, setting]
    }
    
    private func configureTab(controller: UIViewController, title: String, photoName: String) -> UINavigationController {
        let tab = UINavigationController(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: photoName), selectedImage: UIImage(systemName: photoName))
        tab.tabBarItem = tabBarItem
        return tab
    }

}
