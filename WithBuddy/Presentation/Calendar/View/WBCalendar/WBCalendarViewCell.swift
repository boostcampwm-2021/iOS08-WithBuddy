//
//  WBCalendarViewCell.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/04.
//

import UIKit

class WBCalendarViewCell: UICollectionViewCell {
    
    static let identifer = "WBCalendarViewCell"
    private var buddyImageView = UIImageView()
    
    var dayOfCell: UILabel = {
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
    
    private func configure() {
        self.initCell()
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
    
    func initCell() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 0
    }
    
    func highlightToday() {
        self.backgroundColor = UIColor(named: "BackgroundPurple")
        self.layer.cornerRadius = 10
    }
    
    private func configureBuddyImageView() {
        self.addSubview(buddyImageView)
        self.buddyImageView.image = UIImage(named: "")
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
        self.buddyImageView.image = UIImage(named: face)
    }
    
}
