//
//  WBCalendarViewCell.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/04.
//

import UIKit

class WBCalendarViewCell: UICollectionViewCell {
    
    static let identifier = "WBCalendarViewCell"
    private var buddyImageView = UIImageView()
    
    private var dayOfCell: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = UIColor(named: "LabelPurple")
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .systemBackground
        self.buddyImageView.image = nil
    }
    
    private func configure() {
        self.configureCell()
        self.configuredayOfMonth()
        self.configureBuddyImageView()
    }
    
    private func configuredayOfMonth() {
        self.addSubview(dayOfCell)
        self.dayOfCell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayOfCell.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayOfCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 3)
        ])
    }
    
    private func configureCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 0
    }
    
    private func configureBuddyImageView() {
        self.addSubview(buddyImageView)
        self.buddyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            self.buddyImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            self.buddyImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.buddyImageView.topAnchor.constraint(equalTo: self.dayOfCell.bottomAnchor, constant: 1),
            self.buddyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3)
        ])
    }
    
    func update(day: Int, face: String) {
        self.dayOfCell.text = day > 0 ? String(day) : ""
        if !face.isEmpty {
            self.buddyImageView.image = UIImage(named: face)
        }
    }
    
    func highlightCell() {
        self.backgroundColor = UIColor(named: "BackgroundPurple")
        self.layer.cornerRadius = 10
    }
    
}
