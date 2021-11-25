//
//  LatestOldView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

class LatestOldView: UIView {

    private let imageView = UIImageView()
    private let firstLabel = UILabel()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let secondLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func update(description: String) {
        self.firstLabel.text = description
    }
    
    func update(name: String, face: String) {
        let maxLenght = 10
        self.nameLabel.text = String(name.prefix(maxLenght))
        self.imageView.image = UIImage(named: face)
    }
    
    private func configure() {
        self.configureImageView()
        self.configureFirstLabel()
        self.configureStackView()
        self.configureStackLabel()
    }
    
    private func configureImageView() {
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(systemName: "photo")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 130),
            self.imageView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func configureFirstLabel() {
        self.addSubview(self.firstLabel)
        self.firstLabel.font = .systemFont(ofSize: .chartLabelSize)
        self.firstLabel.textAlignment = .center
        self.firstLabel.text = ""
        self.firstLabel.textColor = .systemGray
        self.firstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.firstLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 4),
            self.firstLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func configureStackView() {
        self.addSubview(self.stackView)
        self.stackView.alignment = .center
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.firstLabel.bottomAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.firstLabel.centerXAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureStackLabel() {
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.secondLabel)
        self.nameLabel.text = "위드버디"
        self.secondLabel.text = "님이에요!"
        self.nameLabel.font = .boldSystemFont(ofSize: .chartLabelSize)
        self.secondLabel.font = .systemFont(ofSize: .chartLabelSize)
        self.secondLabel.textColor = .systemGray
    }

}
