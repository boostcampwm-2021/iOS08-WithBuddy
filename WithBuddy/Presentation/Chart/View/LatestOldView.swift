//
//  LatestOldView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class LatestOldView: UIView {

    private let imageView = UIImageView()
    private let firstLabel = UILabel()
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
        self.nameLabel.text = String(name)
        self.imageView.image = UIImage(named: face)
    }
    
    private func configure() {
        self.configureImageView()
        self.configureFirstLabel()
        self.configureNameLabel()
        self.configureSecondLabel()
    }
    
    private func configureImageView() {
        self.addSubview(self.imageView)
        self.imageView.image = .defaultFaceImage
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: .chartBubbleMaxLength),
            self.imageView.heightAnchor.constraint(equalToConstant: .chartBubbleMaxLength)
        ])
    }
    
    private func configureFirstLabel() {
        self.addSubview(self.firstLabel)
        self.firstLabel.font = .systemFont(ofSize: .chartLabelSize)
        self.firstLabel.textAlignment = .center
        self.firstLabel.textColor = .systemGray
        self.firstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.firstLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 4),
            self.firstLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func configureNameLabel() {
        self.addSubview(self.nameLabel)
        self.nameLabel.font = .boldSystemFont(ofSize: .chartLabelSize)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.firstLabel.bottomAnchor),
            self.nameLabel.centerXAnchor.constraint(equalTo: self.firstLabel.centerXAnchor)
        ])
    }
    
    private func configureSecondLabel() {
        self.addSubview(self.secondLabel)
        self.secondLabel.text = .latestOldDescription
        self.secondLabel.font = .systemFont(ofSize: .chartLabelSize)
        self.secondLabel.textColor = .systemGray
        self.secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            self.secondLabel.centerXAnchor.constraint(equalTo: self.nameLabel.centerXAnchor),
            self.secondLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
