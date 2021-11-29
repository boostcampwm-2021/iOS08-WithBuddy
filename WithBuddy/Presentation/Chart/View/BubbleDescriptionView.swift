//
//  BubbleDescriptionView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/29.
//

import UIKit

final class BubbleDescriptionView: UILabel {
    
    private let whiteView = WhiteView()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let editButton = UIButton()

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
    
    private func configure() {
        self.configureWhiteView()
        self.configureStackView()
        self.configureStackItems()
    }
    
    private func configureWhiteView() {
        self.addSubview(self.whiteView)
        self.whiteView.backgroundColor = .systemBackground
        self.whiteView.alpha = .bubbleDescriptionViewAlpha
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.whiteView.topAnchor.constraint(equalTo: self.topAnchor),
            self.whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        self.whiteView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureStackItems() {
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.editButton)
        self.editButton.setImage(.editButtonImage, for: .normal)
    }

}
