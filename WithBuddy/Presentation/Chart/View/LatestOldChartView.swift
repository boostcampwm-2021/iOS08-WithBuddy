//
//  LatestOldChartView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class LatestOldChartView: UIView {
    
    private let titleLabel = PurpleTitleLabel()
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
    
    func update(latestName: String, face: String) {
        self.showStackView()
        self.latestView.update(name: latestName, face: face)
    }
    
    func update(oldName: String, face: String) {
        self.showStackView()
        self.oldView.update(name: oldName, face: face)
    }
    
    func showDefaultView() {
        self.defaultView.isHidden = false
        self.stackView.isHidden = true
    }
    
    private func showStackView() {
        self.defaultView.isHidden = true
        self.stackView.isHidden = false
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureWhiteView()
        self.configureStackView()
        self.configureChartView()
        self.configureDefaultView()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.text = .latestOldChartTitle
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    private func configureWhiteView() {
        self.addSubview(self.whiteView)
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whiteView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.whiteView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: .innerPartInset),
            self.whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.whiteView.heightAnchor.constraint(equalToConstant: .latestOldChartHeight),
            self.whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        self.whiteView.addSubview(self.stackView)
        self.stackView.spacing = .latestOldSpacing
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
        self.latestView.update(description: .latestDescription)
        self.oldView.update(description: .oldDescription)
    }
    
    private func configureDefaultView() {
        self.whiteView.addSubview(self.defaultView)
        self.defaultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.defaultView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.defaultView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.defaultView.widthAnchor.constraint(equalToConstant: .chartDefaultViewLength),
            self.defaultView.heightAnchor.constraint(equalToConstant: .chartDefaultViewHeight)
        ])
    }
    
}
