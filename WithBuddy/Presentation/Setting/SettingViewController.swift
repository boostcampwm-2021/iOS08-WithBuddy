//
//  SettingViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit

class SettingViewController: UIViewController {

    private let userImageView = UIImageView()
    private let userNameTextField = UITextField()
    private let userNameUnderbar = UIView()
    private let modifyButton = UIButton()
    private let removeAllGatheringButton = UIButton()
    private let manageBuddyButton = UIButton()
    private let developerInfoButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.configureUserInfo()
        self.configureButtons()
    }
    
    private func configureUserInfo() {
        self.configureUserImage()
        self.configureUserName()
        self.configureUserNameUnderbar()
        self.configureModifyButton()
    }
    
    private func configureUserImage() {
        self.view.addSubview(self.userImageView)
        self.userImageView.image = UIImage(named: "FacePurple3")
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.userImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.userImageView.widthAnchor.constraint(equalToConstant: 150),
            self.userImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureUserName() {
        self.view.addSubview(self.userNameTextField)
        self.userNameTextField.text = "나정나정"
        self.userNameTextField.isUserInteractionEnabled  = false
        self.userNameTextField.textAlignment = .center
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameTextField.topAnchor.constraint(equalTo: self.userImageView.bottomAnchor),
            self.userNameTextField.widthAnchor.constraint(equalToConstant: self.userNameTextField.intrinsicContentSize.width + 20),
            self.userNameTextField.centerXAnchor.constraint(equalTo: self.userImageView.centerXAnchor)
        ])
    }
    
    private func configureUserNameUnderbar() {
        self.view.addSubview(self.userNameUnderbar)
        self.userNameUnderbar.backgroundColor = UIColor(named: "LabelPurple")
        self.userNameUnderbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameUnderbar.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor),
            self.userNameUnderbar.heightAnchor.constraint(equalToConstant: 1),
            self.userNameUnderbar.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 5),
            self.userNameUnderbar.centerXAnchor.constraint(equalTo: self.userNameTextField.centerXAnchor)
        ])
    }
    
    private func configureModifyButton() {
        self.view.addSubview(self.modifyButton)
        self.modifyButton.setTitle("편집", for: .normal)
        self.modifyButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        self.modifyButton.sizeToFit()
        self.modifyButton.addTarget(self, action: #selector(self.moveToBuddyCustom), for: .touchUpInside)
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
    
    private func configureButtons() {
        self.configureRemoveAllGatheringButton()
        self.configureManageBuddyButton()
        self.configureDeveloperInfo()
    }
    
    private func configureRemoveAllGatheringButton() {
        self.view.addSubview(self.removeAllGatheringButton)
        self.removeAllGatheringButton.setTitle("모임 목록 초기화", for: .normal)
        self.makeButtonLayer(button: self.removeAllGatheringButton, upperView: self.userNameUnderbar)
    }
    
    private func configureManageBuddyButton() {
        self.view.addSubview(self.manageBuddyButton)
        self.manageBuddyButton.setTitle("버디 관리", for: .normal)
        self.manageBuddyButton.addTarget(self, action: #selector(moveToBuddyManage), for: .touchUpInside)
        self.makeButtonLayer(button: self.manageBuddyButton, upperView: self.removeAllGatheringButton)
    }

    private func configureDeveloperInfo() {
        self.view.addSubview(self.developerInfoButton)
        self.developerInfoButton.setTitle("개발자 정보", for: .normal)
        self.developerInfoButton.addTarget(self, action: #selector(moveToDeveloperInfo), for: .touchUpInside)
        self.makeButtonLayer(button: self.developerInfoButton, upperView: self.manageBuddyButton)
    }
    
    private func makeButtonLayer(button: UIButton, upperView: UIView) {
        button.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            button.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 15),
            button.heightAnchor.constraint(equalToConstant: button.intrinsicContentSize.height * 1.5)
        ])
    }
    
    @objc private func moveToBuddyManage(_ sender: UIButton) {
        self.tabBarController?.dismiss(animated: true, completion: {
            self.navigationController?.pushViewController(BuddyManageViewController(), animated: true)
        })
    }
    
    @objc private func moveToDeveloperInfo(_ sender: UIButton) {
        self.tabBarController?.dismiss(animated: true, completion: {
            self.navigationController?.pushViewController(DeveloperInfoViewController(), animated: true)
        })
    }
    
}
