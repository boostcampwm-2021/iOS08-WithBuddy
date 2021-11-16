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
    private let removeAllGatheringButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        self.configureUserInfo()
        self.configureButtons()
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
            self.userNameTextField.widthAnchor.constraint(equalToConstant: self.userNameTextField.intrinsicContentSize.width + 20),
            self.userNameTextField.centerXAnchor.constraint(equalTo: self.userImageView.centerXAnchor)
        ])
        
        self.view.addSubview(userNameUnderbar)
        self.userNameUnderbar.backgroundColor = UIColor(named: "LabelPurple")
        self.userNameUnderbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameUnderbar.widthAnchor.constraint(equalTo: self.userNameTextField.widthAnchor),
            self.userNameUnderbar.heightAnchor.constraint(equalToConstant: 1),
            self.userNameUnderbar.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 5),
            self.userNameUnderbar.centerXAnchor.constraint(equalTo: self.userNameTextField.centerXAnchor)
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
    
    func configureButtons() {
        self.configureRemoveAllGatheringButton()
    }
    
    func configureRemoveAllGatheringButton() {
        self.view.addSubview(removeAllGatheringButton)
        self.removeAllGatheringButton.setTitle("모임 목록 초기화", for: .normal)
        self.removeAllGatheringButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        self.removeAllGatheringButton.contentHorizontalAlignment = .left
        self.removeAllGatheringButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.removeAllGatheringButton.backgroundColor = .systemBackground
        self.removeAllGatheringButton.layer.cornerRadius = 10
        self.removeAllGatheringButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.removeAllGatheringButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.removeAllGatheringButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            self.removeAllGatheringButton.topAnchor.constraint(equalTo: self.userNameUnderbar.bottomAnchor, constant: 30),
            self.removeAllGatheringButton.heightAnchor.constraint(equalToConstant: self.removeAllGatheringButton.intrinsicContentSize.height * 1.5)
        ])
    }
}
