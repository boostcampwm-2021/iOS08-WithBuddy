//
//  RegisterTitleLabel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/15.
//

import UIKit

final class RegisterTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.font = .systemFont(ofSize: 20)
        self.textColor = UIColor(named: "LabelPurple")
    }

}
