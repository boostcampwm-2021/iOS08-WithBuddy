//
//  UserCreateViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/22.
//

import UIKit
import Combine

final class UserCreateViewController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var nameLabel = UILabel()
    private lazy var buddyImageView = UIImageView()
    private lazy var editButton = UIButton()
    private lazy var guideLabel = UILabel()
    private lazy var completeButton = UIButton()
    private let loadingView = LoadingView()
    
    private var userCreateViewModel = UserCreateViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadingView.addFaces()
    }
    
    private func configure() {
        self.view.backgroundColor = .backgroundPurple
        self.configureTitleLabel()
        self.configureStackView()
        self.configureNameLabel()
        self.configureBuddyImageView()
        self.configureEditButton()
        self.configureGuideLabel()
        self.configureCompleteButton()
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
    
    private func bind() {
        self.userCreateViewModel.$buddy
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddy in
                if let buddy = buddy  {
                    self?.nameLabel.text = buddy.name
                    self?.buddyImageView.image = UIImage(named: "\(buddy.face)")
                    self?.completeButton.backgroundColor = .graphPurple
                    self?.completeButton.setTitleColor(.labelPurple, for: .normal)
                }
            }
            .store(in: &self.cancellables)
        
        self.userCreateViewModel.editStartSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddy in
                let buddyCustomViewController = BuddyCustomViewController()
                buddyCustomViewController.delegate = self
                if let buddy = buddy {
                    buddyCustomViewController.configure(by: buddy)
                }
                self?.navigationController?.pushViewController(buddyCustomViewController, animated: true)
            }
            .store(in: &self.cancellables)
        
        self.userCreateViewModel.completeSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddy in
                if buddy != nil {
                    let tabBarViewController = UINavigationController(rootViewController: TabBarViewController())
                    tabBarViewController.modalTransitionStyle = .crossDissolve
                    tabBarViewController.modalPresentationStyle = .fullScreen
                    self?.navigationController?.present(tabBarViewController, animated: true)
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "위드버디"
        self.titleLabel.font = UIFont(name: "Cafe24Ssurround", size: UIScreen.main.bounds.width / 6)
        self.titleLabel.textColor = .labelPurple
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.03),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureStackView() {
        self.view.addSubview(self.stackView)
        self.stackView.alignment = .center
        self.stackView.axis = .vertical
        self.stackView.spacing = 20
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
    }
    
    private func configureNameLabel() {
        self.stackView.addArrangedSubview(self.nameLabel)
        self.nameLabel.text = "아직 설정된 이름이 없어요"
        self.nameLabel.textAlignment = .center
    }
    
    private func configureBuddyImageView() {
        self.stackView.addArrangedSubview(self.buddyImageView)
        self.buddyImageView.image = .defaultFaceImage
        self.buddyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyImageView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 50),
            self.buddyImageView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: -50),
            self.buddyImageView.heightAnchor.constraint(equalTo: self.buddyImageView.widthAnchor)
        ])
    }
    
    private func configureEditButton() {
        self.stackView.addArrangedSubview(self.editButton)
        self.editButton.layer.borderWidth = 1
        self.editButton.layer.borderColor = UIColor.labelPurple?.cgColor
        self.editButton.layer.cornerRadius = 10
        self.editButton.setTitle("캐릭터 수정하기", for: .normal)
        self.editButton.setTitleColor(.labelPurple, for: .normal)
        self.editButton.addTarget(self, action: #selector(self.didEditButtonTouched), for: .touchUpInside)
        
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.editButton.widthAnchor.constraint(equalToConstant: 150),
            self.editButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didEditButtonTouched(_ sender: UIButton) {
        self.userCreateViewModel.startEditing()
    }
    
    private func configureGuideLabel() {
        self.stackView.addArrangedSubview(self.guideLabel)
        self.guideLabel.text = "내 이름과 캐릭터는 언제든지 변경할 수 있어요!"
        self.guideLabel.adjustsFontSizeToFitWidth = true
        self.guideLabel.textAlignment = .center
    }
    
    private func configureCompleteButton() {
        self.view.addSubview(self.completeButton)
        self.completeButton.backgroundColor = .systemGray3
        self.completeButton.layer.cornerRadius = 10
        self.completeButton.setTitle("내 캐릭터 생성 완료", for: .normal)
        self.completeButton.addTarget(self, action: #selector(self.didCompleteButtonTouched), for: .touchUpInside)
        
        self.completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.completeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            self.completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.completeButton.widthAnchor.constraint(equalToConstant: 300),
            self.completeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didCompleteButtonTouched(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.completeButton.transform = CGAffineTransform(scaleX: CGFloat(0.9), y: CGFloat(0.9))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.completeButton.transform = CGAffineTransform.identity
            } completion: { [weak self] _ in
                self?.userCreateViewModel.endEditing()
            }
        }
    }

}

extension UserCreateViewController: BuddyCustomDelegate {
    
    func didBuddyEditCompleted(_ buddy: Buddy) {
        self.userCreateViewModel.didUserChanged(buddy: buddy)
    }
    
    func didBuddyAddCompleted(_ buddy: Buddy) {
        self.userCreateViewModel.didUserChanged(buddy: buddy)
    }
    
}
