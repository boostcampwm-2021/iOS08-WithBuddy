//
//  SettingViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit

class SettingViewController: UIViewController {

    static let identifier = "SettingViewController"
    private let userImageView = UIImageView()
    private let userNameTextField = UITextField()
    private let userNameUnderbar = UIView()
    private let modifyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        self.configureUserInfo()
    }
    
    func configureUserInfo() {
        self.view.addSubview(userImageView)
        self.userImageView.image = UIImage(named: "FacePurple3")
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.userImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.userImageView.widthAnchor.constraint(equalToConstant: 150),
            self.userImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        self.view.addSubview(userNameTextField)
        self.userNameTextField.text = "나정나정"
        self.userNameTextField.isUserInteractionEnabled  = false
        self.userNameTextField.textAlignment = .center
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameTextField.topAnchor.constraint(equalTo: self.userImageView.bottomAnchor),
            self.userNameTextField.widthAnchor.constraint(equalToConstant: 200),
            self.userNameTextField.centerXAnchor.constraint(equalTo: self.userImageView.centerXAnchor)
        ])
        
        self.view.addSubview(modifyButton)
        self.modifyButton.setTitle("편집", for: .normal)
        self.modifyButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        self.modifyButton.sizeToFit()
        self.modifyButton.addTarget(self, action: #selector(moveToBuddyCustom), for: .touchUpInside)
        self.modifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.modifyButton.topAnchor.constraint(equalTo: self.userImageView.topAnchor),
            self.modifyButton.trailingAnchor.constraint(equalTo: self.userImageView.trailingAnchor),
            self.modifyButton.widthAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.width),
            self.modifyButton.heightAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.height)
        ])
    }
    
    @objc private func moveToBuddyCustom(_ sender: UIButton) {
        self.tabBarController?.dismiss(animated: true, completion: {
            self.navigationController?.pushViewController(BuddyCustomViewController(), animated: true)
        })
    }
}
