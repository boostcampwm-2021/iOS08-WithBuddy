//
//  WBCalendar.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class WBCalendar: UIView {
    private let testView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurtestView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurtestView()
    }
    
    private func configurtestView() {
        self.addSubview(testView)
        self.testView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.testView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.testView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.testView.topAnchor.constraint(equalTo: self.topAnchor),
            self.testView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
