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
        self.configureModifyButton()
    }
    
    private func configureUserImage() {
        self.view.addSubview(self.userImageView)
        self.userImageView.image = UIImage(named: "FacePurple3")
        self.userImageView.sizeToFit()
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.userImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.userImageView.widthAnchor.constraint(equalToConstant: 120),
            self.userImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureUserName() {
        self.view.addSubview(self.userNameTextField)
        self.userNameTextField.text = "나정나정"
        self.userNameTextField.font = .systemFont(ofSize: .titleLabelSize)
        self.userNameTextField.isUserInteractionEnabled  = false
        self.userNameTextField.textAlignment = .center
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameTextField.bottomAnchor.constraint(equalTo: self.userImageView.centerYAnchor, constant: -10),
            self.userNameTextField.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: 20),
            self.userNameTextField.widthAnchor.constraint(equalToConstant: self.userNameTextField.intrinsicContentSize.width),
            self.userNameTextField.heightAnchor.constraint(equalToConstant: self.userNameTextField.intrinsicContentSize.height)
        ])
    }
    
    private func configureModifyButton() {
        self.view.addSubview(self.modifyButton)
        self.modifyButton.setTitle("프로필 수정", for: .normal)
        self.modifyButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        self.modifyButton.layer.borderWidth = 1
        self.modifyButton.layer.cornerRadius = 5
        self.modifyButton.layer.borderColor = UIColor(named: "LabelPurple")?.cgColor
        self.modifyButton.sizeToFit()
        self.modifyButton.addTarget(self, action: #selector(self.moveToBuddyCustom), for: .touchUpInside)
        self.modifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.modifyButton.topAnchor.constraint(equalTo: self.userImageView.centerYAnchor, constant: 5),
            self.modifyButton.leadingAnchor.constraint(equalTo: self.userNameTextField.leadingAnchor),
            self.modifyButton.widthAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.width + 20),
            self.modifyButton.heightAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.height)
        ])
    }
    
    @objc private func moveToBuddyCustom(_ sender: UIButton) {
        self.modifyButton.animateButtonTap(scale: 0.9)
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
        self.makeButtonLayer(button: self.removeAllGatheringButton, upperView: self.userNameTextField, constant: 100)
        self.removeAllGatheringButton.addTarget(self, action: #selector(removeAlert), for: .touchUpInside)
    }
    
    @objc private func removeAlert() {
        self.removeAllGatheringButton.animateButtonTap(scale: 0.9)
        let alert = UIAlertController(title: nil, message: "모임 목록을 정말로 초기화하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func configureManageBuddyButton() {
        self.view.addSubview(self.manageBuddyButton)
        self.manageBuddyButton.setTitle("버디 관리", for: .normal)
        self.manageBuddyButton.addTarget(self, action: #selector(moveToBuddyManage), for: .touchUpInside)
        self.makeButtonLayer(button: self.manageBuddyButton, upperView: self.removeAllGatheringButton, constant: 15)
    }

    private func configureDeveloperInfo() {
        self.view.addSubview(self.developerInfoButton)
        self.developerInfoButton.setTitle("개발자 정보", for: .normal)
        self.developerInfoButton.addTarget(self, action: #selector(moveToDeveloperInfo), for: .touchUpInside)
        self.makeButtonLayer(button: self.developerInfoButton, upperView: self.manageBuddyButton, constant: 15)
    }

    private func makeButtonLayer(button: UIButton, upperView: UIView, constant: CGFloat) {
        button.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            button.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: constant),
            button.heightAnchor.constraint(equalToConstant: button.intrinsicContentSize.height * 1.5)
        ])
    }
    
    @objc private func moveToBuddyManage(_ sender: UIButton) {
        self.navigationController?.pushViewController(BuddyManageViewController(), animated: true)
    }
    
    @objc private func moveToDeveloperInfo(_ sender: UIButton) {
        self.navigationController?.pushViewController(DeveloperInfoViewController(), animated: true)
    }
    
}
