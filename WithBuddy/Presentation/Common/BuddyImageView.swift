//
//  BuddyView.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/23.
//

import UIKit

class BuddyView: UIImageView {
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.height * 0.5
        self.layer.masksToBounds = true
    }
    
}
