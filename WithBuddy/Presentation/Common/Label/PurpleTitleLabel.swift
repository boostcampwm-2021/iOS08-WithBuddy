//
//  PurpleTitleLabel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class PurpleTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.font = .boldSystemFont(ofSize: .titleLabelSize)
        self.textColor = UIColor(named: "LabelPurple")
    }

}
