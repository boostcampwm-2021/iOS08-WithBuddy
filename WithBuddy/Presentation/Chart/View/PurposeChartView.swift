//
//  PurposeChartView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class PurposeChartView: UIView {
    
    private let nameLabel = PurpleTitleLabel()
    private let titleLabel = BlackTitleLabel()
    private let whiteView = WhiteView()
    private let stackView = UIStackView()
    private let firstPurposeView = PurposeView()
    private let secondPurposeView = PurposeView()
    private let thirdPurposeView = PurposeView()
    private let fourthPurposeView = PurposeView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func update(name: String) {
        self.nameLabel.text = name
    }
    
    func update(list: [String?]) {
        let first = list.indices ~= 0 ? list[0] : nil
        let second = list.indices ~= 1 ? list[1] : nil
        let third = list.indices ~= 2 ? list[2] : nil
        let fourth = list.indices ~= 3 ? list[3] : nil
        
        if first == nil {
            self.configureDefaultPurpose()
            return
        }
        
        self.update(name: first, view: firstPurposeView)
        self.update(name: second, view: secondPurposeView)
        self.update(name: third, view: thirdPurposeView)
        self.update(name: fourth, view: fourthPurposeView)
    }
    
    private func update(name: String?, view: PurposeView) {
        if let name = name {
            view.update(image: name, purpose: name)
            view.isHidden = false
            return
        }
        view.isHidden = true
    }
    
    private func configure() {
        self.configureNameLabel()
        self.configureWhiteView()
        self.configureTitleLabel()
        self.configureStackView()
        self.configurePurposeView()
        self.configureDefaultPurpose()
    }
    
    private func configureNameLabel() {
        self.addSubview(self.nameLabel)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "님의 만남 목적"
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor)
        ])
    }
    
    private func configureWhiteView() {
        self.addSubview(self.whiteView)
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whiteView.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.whiteView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.whiteView.heightAnchor.constraint(equalToConstant: 100),
            self.whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        self.whiteView.addSubview(self.stackView)
        self.stackView.spacing = 10
        self.stackView.alignment = .center
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.stackView.heightAnchor.constraint(equalTo: self.whiteView.heightAnchor)
        ])
    }
    
    private func configurePurposeView() {
        self.stackView.addArrangedSubview(self.firstPurposeView)
        self.stackView.addArrangedSubview(self.secondPurposeView)
        self.stackView.addArrangedSubview(self.thirdPurposeView)
        self.stackView.addArrangedSubview(self.fourthPurposeView)
    }
    
    private func configureDefaultPurpose() {
        self.firstPurposeView.isHidden = false
        self.secondPurposeView.isHidden = false
        self.thirdPurposeView.isHidden = false
        self.fourthPurposeView.isHidden = false
        self.firstPurposeView.update(image: "DefaultHobby", purpose: "취미")
        self.secondPurposeView.update(image: "DefaultStudy", purpose: "공부")
        self.thirdPurposeView.update(image: "DefaultMeal", purpose: "식사")
        self.fourthPurposeView.update(image: "DefaultSport", purpose: "운동")
    }

}
