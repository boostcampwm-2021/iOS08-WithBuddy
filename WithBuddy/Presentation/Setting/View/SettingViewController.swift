//
//  SettingViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine
import SafariServices

final class SettingViewController: UIViewController {
    
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let modifyButton = UIButton()
    private let removeAllGatheringButton = UIButton()
    private let manageBuddyButton = UIButton()
    private let developerInfoButton = UIButton()
    private let settingViewModel = SettingViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    private func bind() {
        self.settingViewModel.deleteSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if message.0 == "삭제 성공" { self?.deleteNotification() }
                let alert = UIAlertController(title: message.0, message: message.1, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
            }.store(in: &self.cancellable)
        
        self.settingViewModel.$myBuddy
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddy in
                guard let buddy  = buddy else { return }
                self?.userImageView.image = UIImage(named: "\(buddy.face)")
                self?.userNameLabel.text = buddy.name
            }
            .store(in: &self.cancellable)
    }
    
    private func deleteNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func configure() {
        self.configureUserInfo()
        self.configureButtons()
    }
    
    private func configureUserInfo() {
        self.configureUserImage()
        self.configureUserName()
        self.configureModifyButton()
        self.settingViewModel.reloadMyBuddy()
    }
    
    private func configureUserImage() {
        self.view.addSubview(self.userImageView)
        self.userImageView.image = .defaultFaceImage
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
        self.view.addSubview(self.userNameLabel)
        self.userNameLabel.text = "UserName"
        self.userNameLabel.font = .systemFont(ofSize: .titleLabelSize)
        self.userNameLabel.textAlignment = .center
        self.userNameLabel.font = UIFont.systemFont(ofSize: 23)
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameLabel.bottomAnchor.constraint(equalTo: self.userImageView.centerYAnchor, constant: -10),
            self.userNameLabel.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: .plusInset)
        ])
    }
    
    private func configureModifyButton() {
        self.view.addSubview(self.modifyButton)
        self.modifyButton.setTitle("프로필 수정", for: .normal)
        self.modifyButton.backgroundColor = .labelPurple
        self.modifyButton.layer.cornerRadius = .buttonCornerRadius
        self.modifyButton.tintColor = .white
        self.modifyButton.sizeToFit()
        self.modifyButton.addTarget(self, action: #selector(self.didProfileEditButtonTouched), for: .touchUpInside)
        self.modifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.modifyButton.topAnchor.constraint(equalTo: self.userImageView.centerYAnchor, constant: 5),
            self.modifyButton.leadingAnchor.constraint(equalTo: self.userNameLabel.leadingAnchor),
            self.modifyButton.widthAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.width + 20),
            self.modifyButton.heightAnchor.constraint(equalToConstant: self.modifyButton.intrinsicContentSize.height)
        ])
    }
    
    @objc private func didProfileEditButtonTouched(_ sender: UIButton) {
        self.modifyButton.animateButtonTap(scale: 0.9)
        guard let myBuddy = self.settingViewModel.myBuddy else { return }
        let buddyCustomViewController = BuddyCustomViewController()
        buddyCustomViewController.delegate = self
        buddyCustomViewController.configure(by: myBuddy)
        buddyCustomViewController.title = "프로필 수정"
        self.navigationController?.pushViewController(buddyCustomViewController, animated: true)
    }
    
    private func configureButtons() {
        self.configureRemoveAllGatheringButton()
        self.configureManageBuddyButton()
        self.configureDeveloperInfo()
    }
    
    private func configureRemoveAllGatheringButton() {
        self.view.addSubview(self.removeAllGatheringButton)
        self.removeAllGatheringButton.setTitle("모임 목록 초기화", for: .normal)
        self.makeButtonLayer(button: self.removeAllGatheringButton, upperView: self.userNameLabel, constant: 100)
        self.removeAllGatheringButton.addTarget(self, action: #selector(self.didRemoveButtonTouched), for: .touchUpInside)
    }
    
    @objc private func didRemoveButtonTouched() {
        self.removeAllGatheringButton.animateButtonTap(scale: 0.9)
        let alert = UIAlertController(title: nil, message: "모임 목록을 정말로 초기화하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.settingViewModel.didGatheringResetTouched()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureManageBuddyButton() {
        self.view.addSubview(self.manageBuddyButton)
        self.manageBuddyButton.setTitle("버디 관리", for: .normal)
        self.manageBuddyButton.addTarget(self, action: #selector(self.didBuddyManageButtonTouched), for: .touchUpInside)
        self.makeButtonLayer(button: self.manageBuddyButton, upperView: self.removeAllGatheringButton, constant: 15)
    }
    
    private func configureDeveloperInfo() {
        self.view.addSubview(self.developerInfoButton)
        self.developerInfoButton.setTitle("개발자 정보", for: .normal)
        self.developerInfoButton.addTarget(self, action: #selector(self.didDeveloperInfoTouched), for: .touchUpInside)
        self.makeButtonLayer(button: self.developerInfoButton, upperView: self.manageBuddyButton, constant: 15)
    }
    
    private func makeButtonLayer(button: UIButton, upperView: UIView, constant: CGFloat) {
        button.setTitleColor(.labelPurple, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: CGFloat.zero, left: 15, bottom: CGFloat.zero, right: CGFloat.zero)
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
    
    @objc private func didBuddyManageButtonTouched(_ sender: UIButton) {
        self.navigationController?.pushViewController(BuddyManageViewController(), animated: true)
    }
    
    @objc private func didDeveloperInfoTouched(_ sender: UIButton) {
        guard let wikiURL = URL(string: "https://github.com/boostcampwm-2021/iOS08-WithBuddy/wiki") else { return }
        let developSafariView: SFSafariViewController = SFSafariViewController(url: wikiURL)
        self.present(developSafariView, animated: true, completion: nil)
    }
    
}

extension SettingViewController: BuddyCustomDelegate {
    
    func didBuddyAddCompleted(_ buddy: Buddy) {
        self.settingViewModel.didMyBuddyChanged(buddy: buddy)
        self.settingViewModel.reloadMyBuddy()
    }
    
    func didBuddyEditCompleted(_ buddy: Buddy) {
        self.settingViewModel.didMyBuddyChanged(buddy: buddy)
        self.settingViewModel.reloadMyBuddy()
    }
    
}
