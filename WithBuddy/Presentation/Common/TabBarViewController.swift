//
//  TabbarViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private var registerButton = UIButton()
    private var prevIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.tabBar.backgroundColor = .systemBackground
        self.configure()
    }
    
    private func configure() {
        self.configureTabBar()
        self.configureButton()
    }
    
    private func configureTabBar() {
        let calendar = configureTab(controller: CalendarViewController(), title: "일정", photoName: "calendar")
        let chart = configureTab(controller: ChartViewController(), title: "통계", photoName: "chart.bar.xaxis")
        let register = configureTab(controller: RegisterViewController(), title: "모임등록", photoName: "person.3.fill")
        let list = configureTab(controller: ListViewController(), title: "목록", photoName: "list.bullet.rectangle.fill")
        let setting = configureTab(controller: SettingViewController(), title: "설정", photoName: "gearshape.fill")
        self.viewControllers = [calendar, chart, register, list, setting]
    }
    
    private func configureTab(controller: UIViewController, title: String, photoName: String) -> UINavigationController {
        let tab = UINavigationController(rootViewController: controller)
        if controller is RegisterViewController { return tab }
        let tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: photoName), selectedImage: UIImage(systemName: photoName))
        tab.tabBarItem = tabBarItem
        return tab
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.filled()
        var attText = AttributedString("모임등록")
        attText.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
        config.attributedTitle = attText
        config.imagePadding = 7
        config.image = UIImage(systemName: "person.3.fill")
        config.imagePlacement = .top
        config.cornerStyle = .capsule
        
        self.registerButton = UIButton(configuration: config, primaryAction: nil)
        self.registerButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        self.registerButton.titleLabel?.font = .systemFont(ofSize: 10)
        self.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        
        self.view.addSubview(self.registerButton)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.registerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.registerButton.widthAnchor.constraint(equalToConstant: 70),
            self.registerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    @objc private func registerAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
}
