//
//  PurpleLabel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/22.
//

import UIKit

final class PurpleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.font = .systemFont(ofSize: .labelSize)
        self.textColor = .labelPurple
    }

}
