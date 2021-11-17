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
    
    func fadeAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        let fadeAnimation = CATransition()

        fadeAnimation.type = CATransitionType.fade
        fadeAnimation.duration = duration
        self.layer.add(fadeAnimation, forKey: "fadeAnimation")
    }
    
}
