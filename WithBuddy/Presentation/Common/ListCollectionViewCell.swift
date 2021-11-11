//
//  ListCollectionViewCell.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "listCollectionViewCell"
    private let dateLabel = UILabel()
    private let buddyLabel = UILabel()
    private let typeLabel = UILabel()
    private var buddyStackView = UIStackView()
    private var typeStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.buddyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func update(date: Date, buddyImageList: [String], typeList: [String]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.dateLabel.text = dateFormatter.string(from: date)
        self.update(imageNames: buddyImageList, stackView: self.buddyStackView)
        self.update(imageNames: typeList, stackView: self.typeStackView)
    }
    
    private func update(imageNames: [String], stackView: UIStackView) {
        (0..<min(4, imageNames.count)).forEach { index in
            guard let image = UIImage(named: imageNames[index]) else { return }
            let imageView = UIImageView(image: image)
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 44),
                imageView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.configureDateLabel()
        self.configureBuddyLabel()
        self.configureTypeLabel()
        self.configureBuddyStackView()
        self.configureTypeStackView()
    }
    
    private func configureDateLabel() {
        self.addSubview(self.dateLabel)
        self.dateLabel.text = "2021.11.04"
        self.dateLabel.textColor = UIColor(named: "LabelPurple")
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureBuddyLabel() {
        self.addSubview(self.buddyLabel)
        self.buddyLabel.text = "버디"
        self.buddyLabel.textColor = UIColor(named: "LabelPurple")
        self.buddyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 25),
            self.buddyLabel.leadingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor)
        ])
    }
    
    private func configureTypeLabel() {
        self.addSubview(self.typeLabel)
        self.typeLabel.text = "목적"
        self.typeLabel.textColor = UIColor(named: "LabelPurple")
        self.typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeLabel.topAnchor.constraint(equalTo: self.buddyLabel.bottomAnchor, constant: 25),
            self.typeLabel.leadingAnchor.constraint(equalTo: self.buddyLabel.leadingAnchor)
        ])
    }
    
    private func configureBuddyStackView() {
        self.addSubview(self.buddyStackView)
        self.buddyStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyStackView.leadingAnchor.constraint(equalTo: self.buddyLabel.trailingAnchor, constant: 10),
            self.buddyStackView.centerYAnchor.constraint(equalTo: self.buddyLabel.centerYAnchor)
        ])
    }
    
    private func configureTypeStackView() {
        self.addSubview(self.typeStackView)
        self.typeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeStackView.leadingAnchor.constraint(equalTo: self.typeLabel.trailingAnchor, constant: 10),
            self.typeStackView.centerYAnchor.constraint(equalTo: self.typeLabel.centerYAnchor)
        ])
    }
    
}
