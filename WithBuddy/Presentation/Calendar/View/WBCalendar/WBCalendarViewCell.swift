//
//  WBCalendarViewCell.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/04.
//

import UIKit

class WBCalendarViewCell: UICollectionViewCell {
    static let identifer = "WBCalendarViewCell"
    
    var dayOfMonth: UILabel = {
        let label = UILabel()
        label.text = "1"
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
        self.configuredayOfMonth()
    }
    
    private func configuredayOfMonth() {
        self.addSubview(dayOfMonth)
        self.dayOfMonth.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayOfMonth.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayOfMonth.topAnchor.constraint(equalTo: self.topAnchor, constant: 3)
        ])
    }
}
