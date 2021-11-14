//
//  LatestOldChartView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class LatestOldChartView: UIView {
    
    private let nameLabel = NameLabel()
    private let titleLabel = TitleLabel()
    private let whiteView = WhiteView()
    private let stackView = UIStackView()
    private let latestView = LatestOldView()
    private let oldView = LatestOldView()
    private let defaultView = DefaultView()

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
    
    func update(latestName: String, face: String) {
        self.showStackView()
        self.latestView.update(name: latestName, face: face)
    }
    
    func update(oldName: String, face: String) {
        self.showStackView()
        self.oldView.update(name: oldName, face: face)
    }
    
    private func showStackView() {
        if self.stackView.isHidden {
            self.defaultView.isHidden.toggle()
            self.stackView.isHidden.toggle()
        }
    }
    
    private func configure() {
        self.configureNameLabel()
        self.configureWhiteView()
        self.configureTitleLabel()
        self.configureStackView()
        self.configureChartView()
        self.configureDefaultView()
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
        self.titleLabel.text = "님이 가장 최근/오래전에 만난 버디"
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
            self.whiteView.heightAnchor.constraint(equalToConstant: 180),
            self.whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        self.whiteView.addSubview(self.stackView)
        self.stackView.spacing = 30
        self.stackView.alignment = .center
        self.stackView.isHidden = true
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.stackView.heightAnchor.constraint(equalTo: self.whiteView.heightAnchor)
        ])
    }
    
    private func configureChartView() {
        self.stackView.addArrangedSubview(self.latestView)
        self.stackView.addArrangedSubview(self.oldView)
        self.latestView.update(description: "가장 최근에 만난 버디는")
        self.oldView.update(description: "만난지 가장 오래된 버디는")
    }
    
    private func configureDefaultView() {
        self.whiteView.addSubview(self.defaultView)
        self.defaultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.defaultView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.defaultView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.defaultView.widthAnchor.constraint(equalToConstant: 200),
            self.defaultView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
}
