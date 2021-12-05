//
//  ListCollectionViewCell.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    
    static let identifier = "listTableViewCell"
    private let dateLabel = UILabel()
    private let buddyLabel = UILabel()
    private let purposeLabel = UILabel()
    private var buddyStackView = UIStackView()
    private var purposeStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.buddyStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.purposeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func update(date: Date, buddyImageList: [String], typeList: [String]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.dateLabel.text = dateFormatter.string(from: date)
        self.update(imageNames: buddyImageList, stackView: self.buddyStackView)
        self.update(imageNames: typeList, stackView: self.purposeStackView)
    }
    
    private func update(imageNames: [String], stackView: UIStackView) {
        (Int.zero..<min(4, imageNames.count)).forEach { index in
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
        self.configureDateLabel()
        self.configureBuddyLabel()
        self.configurePurposeLabel()
        self.configureBuddyStackView()
        self.configurePurposeStackView()
    }
    
    private func configureDateLabel() {
        self.addSubview(self.dateLabel)
        self.dateLabel.text = "2021.11.04"
        self.dateLabel.textColor = .labelPurple
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .plusInset),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .minusInset)
        ])
    }
    
    private func configureBuddyLabel() {
        self.addSubview(self.buddyLabel)
        self.buddyLabel.text = "버디"
        self.buddyLabel.textColor = .labelPurple
        self.buddyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 25),
            self.buddyLabel.leadingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor)
        ])
    }
    
    private func configurePurposeLabel() {
        self.addSubview(self.purposeLabel)
        self.purposeLabel.text = "목적"
        self.purposeLabel.textColor = .labelPurple
        self.purposeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeLabel.topAnchor.constraint(equalTo: self.buddyLabel.bottomAnchor, constant: 25),
            self.purposeLabel.leadingAnchor.constraint(equalTo: self.buddyLabel.leadingAnchor)
        ])
    }
    
    private func configureBuddyStackView() {
        self.addSubview(self.buddyStackView)
        self.buddyStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyStackView.leadingAnchor.constraint(equalTo: self.buddyLabel.trailingAnchor, constant: .innerPartInset),
            self.buddyStackView.centerYAnchor.constraint(equalTo: self.buddyLabel.centerYAnchor)
        ])
    }
    
    private func configurePurposeStackView() {
        self.addSubview(self.purposeStackView)
        self.purposeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeStackView.leadingAnchor.constraint(equalTo: self.purposeLabel.trailingAnchor, constant: .innerPartInset),
            self.purposeStackView.centerYAnchor.constraint(equalTo: self.purposeLabel.centerYAnchor)
        ])
    }
    
}
