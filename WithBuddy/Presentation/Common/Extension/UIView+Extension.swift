//
//  UIViewExtension.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/11.
//

import UIKit

extension UIView {
    
    func animateButtonTap(duration: Double, scale: Float) {
        UIView.animate(withDuration: duration/2) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: duration/2) {
                self?.transform = CGAffineTransform.identity
            }
        }
    }
    
    func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        let leftToRightTransition = CATransition()

        leftToRightTransition.type = CATransitionType.fade
        leftToRightTransition.subtype = CATransitionSubtype.fromRight
        leftToRightTransition.duration = duration
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
    
    func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        let rightToLeftTransition = CATransition()

        rightToLeftTransition.type = CATransitionType.fade
        rightToLeftTransition.subtype = CATransitionSubtype.fromLeft
        rightToLeftTransition.duration = duration
        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
    }
    
}
