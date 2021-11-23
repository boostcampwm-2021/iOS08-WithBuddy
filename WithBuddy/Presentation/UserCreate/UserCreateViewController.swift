//
//  UserCreateViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/22.
//

import UIKit

final class UserCreateViewController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var nameLabel = UILabel()
    private lazy var buddyImageView = UIImageView()
    private lazy var editButton = UIButton()
    private lazy var guideLabel = UILabel()
    private lazy var completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.configureTitleLabel()
        self.configureStackView()
        self.configureNameLabel()
        self.configureBuddyImageView()
        self.configureEditButton()
        self.configureGuideLabel()
        self.configureCompleteButton()
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = "위드버디"
        self.titleLabel.font = UIFont(name: "Cafe24Ssurround", size: 40)
        self.titleLabel.textColor = UIColor(named: "LabelPurple")
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
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
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])
    }
    
    private func configureBuddyImageView() {
        self.stackView.addArrangedSubview(self.buddyImageView)
        self.buddyImageView.image = UIImage(named: "DefaultFace")
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
        self.editButton.layer.borderColor = UIColor(named: "LabelPurple")?.cgColor
        self.editButton.layer.cornerRadius = 10
        self.editButton.setTitle("캐릭터 수정하기", for: .normal)
//        }
        self.editButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.editButton.widthAnchor.constraint(equalToConstant: 150),
            self.editButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureGuideLabel() {
        self.stackView.addArrangedSubview(self.guideLabel)
        self.guideLabel.text = "내 이름과 캐릭터는 언제든지 변경할 수 있어요!"
        self.guideLabel.adjustsFontSizeToFitWidth = true
        self.guideLabel.textAlignment = .center
        
        self.guideLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])
    }
    
    private func configureCompleteButton() {
        self.view.addSubview(self.completeButton)
        self.completeButton.backgroundColor = .white
        self.completeButton.layer.cornerRadius = 10
        self.completeButton.setTitle("내 캐릭터 생성 완료", for: .normal)
        self.completeButton.setTitleColor(UIColor(named: "LabelPurple"), for: .normal)
        
        self.completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.completeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            self.completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.completeButton.widthAnchor.constraint(equalToConstant: 300),
            self.completeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
