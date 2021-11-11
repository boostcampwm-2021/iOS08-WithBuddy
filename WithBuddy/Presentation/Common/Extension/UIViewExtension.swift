//
//  UIViewExtension.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/11.
//

import UIKit

extension UIView {
    func animateButtonTap(scale: Float) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.transform = CGAffineTransform.identity
            }
        }
    }
}
