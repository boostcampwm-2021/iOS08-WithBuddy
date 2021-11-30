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
    private let loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPurple
        self.tabBar.backgroundColor = .systemBackground
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadingView.addFaces()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelPurple as Any]
    }
    
    private func configure() {
        self.configureTabBarItems()
        self.configureButton()
    }

    func configureLoading() {
        self.view.addSubview(self.loadingView)
        self.loadingView.backgroundColor = .graphPurple2
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configureTabBarItems() {
        let calendar = CalendarViewController()
        let chart = ChartViewController()
        let register = RegisterViewController()
        let list = ListViewController()
        let setting = SettingViewController()
        self.configureTab(controller: calendar, title: "일정", photoName: "calendar")
        self.configureTab(controller: chart, title: "통계", photoName: "chart.bar.xaxis")
        self.configureTab(controller: list, title: "목록", photoName: "list.bullet.rectangle.fill")
        self.configureTab(controller: setting, title: "설정", photoName: "gearshape.fill")
        self.viewControllers = [calendar, chart, register, list, setting]
    }
    
    private func configureTab(controller: UIViewController, title: String, photoName: String) {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: photoName), selectedImage: UIImage(systemName: photoName))
        controller.tabBarItem = tabBarItem
    }
    
    private func configureButton() {
        let circleDiameter = self.tabBar.layer.bounds.height * 1.5
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            var attText = AttributedString("모임등록")
            attText.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
            config.attributedTitle = attText
            config.imagePadding = 7
            config.image = UIImage(systemName: "person.3.fill")
            config.imagePlacement = .top
            config.cornerStyle = .capsule
            self.registerButton = UIButton(configuration: config, primaryAction: nil)
        } else {
            let button = UIButton()
            button.backgroundColor = .labelPurple
            button.setTitle("모임등록", for: .normal)
            button.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
            button.setPreferredSymbolConfiguration(.init(pointSize: 21, weight: .regular, scale: .default), forImageIn: .normal)
            button.tintColor = .white
            guard let image = button.imageView?.image,
                  let titleLabel = button.titleLabel,
                  let titleText = titleLabel.text else { return }
            let titleSize = titleText.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font as Any])

            button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + 3), left: 0, bottom: 0, right: -image.size.width)
            button.titleEdgeInsets = UIEdgeInsets(top: 3, left: -titleSize.width/2-11, bottom: -image.size.height, right: 0)
            self.registerButton = button
        }
        self.registerButton.frame = CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter)
        self.registerButton.layer.cornerRadius = 0.5 * self.registerButton.bounds.size.width
        self.registerButton.titleLabel?.font = .systemFont(ofSize: 10)
        self.registerButton.addTarget(self, action: #selector(didRegisterButtonTouched), for: .touchUpInside)
        
        self.view.addSubview(self.registerButton)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.registerButton.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -circleDiameter / 6),
            self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.registerButton.widthAnchor.constraint(equalToConstant: circleDiameter),
            self.registerButton.heightAnchor.constraint(equalToConstant: circleDiameter)
        ])
    }
    
    @objc private func didRegisterButtonTouched(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
}
