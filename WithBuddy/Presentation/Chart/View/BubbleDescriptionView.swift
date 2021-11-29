//
//  BubbleDescriptionView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/29.
//

import UIKit

final class BubbleDescriptionView: UILabel {
    
    private let stackView = UIStackView()
    private let nameLabel = PurpleLabel()
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
        self.backgroundColor = .systemBackground
        self.alpha = .bubbleDescriptionViewAlpha
        self.configureStackView()
        self.configureStackItems()
    }
    
    private func configureStackView() {
        self.addSubview(self.stackView)
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
