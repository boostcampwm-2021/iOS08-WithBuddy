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
        self.view.backgroundColor = .systemBackground
        let tab = RegisterViewController()
        let tabBarItem = UITabBarItem(title: "aaa", image: UIImage(systemName: "photo"), selectedImage: UIImage(systemName: "photo"))
        tab.tabBarItem = tabBarItem
        self.viewControllers = [tab]
    }
}

