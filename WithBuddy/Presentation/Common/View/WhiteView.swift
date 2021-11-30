//
//  WhiteView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class WhiteView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = .whiteViewCornerRadius
    }

}
