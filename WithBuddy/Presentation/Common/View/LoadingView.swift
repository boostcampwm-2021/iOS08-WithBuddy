//
//  LoadingView.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/23.
//

import UIKit

final class LoadingView: UIView {

    private var titleLabel = UILabel()
    lazy var animator = UIDynamicAnimator(referenceView: self)
    lazy var gravity = UIGravityBehavior()
    lazy var collider = UICollisionBehavior()
    lazy var dynamicItemBehavior = UIDynamicItemBehavior()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    private func configure() {
        self.configureDynamicItemBehavior()
        self.configureTitle()
    }

    private func configureDynamicItemBehavior() {
        self.gravity.magnitude = 1
        self.collider.translatesReferenceBoundsIntoBoundary = true
        self.dynamicItemBehavior.elasticity = 0.65
        self.dynamicItemBehavior.allowsRotation = true
        self.dynamicItemBehavior.density = 1.5
    }
    
    private func configureTitle() {
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "위드버디"
        self.appNameAnimation()
        self.titleLabel.font = UIFont(name: "Cafe24Ssurround", size: UIScreen.main.bounds.width / 6)
        self.titleLabel.textColor = .white
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.2),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(equalToConstant: self.titleLabel.intrinsicContentSize.width)
        ])
    }

    func addFaces() {
        let fallingBuddys = ["BlueDrop", "GreenDrop", "RedDrop", "PinkDrop", "YellowDrop"]
        let width = self.frame.width
        let height = self.frame.height
        let fallingPosition = [CGPoint(x: width * 0.02, y: height * 0.06),
                               CGPoint(x: width * 0.2, y: height * 0.2),
                               CGPoint(x: width * 0.3, y: height * 0.005),
                               CGPoint(x: width * 0.6, y: height * 0.01),
                               CGPoint(x: width * 0.7, y: height * 0.1)]

        for idx in 0..<fallingBuddys.count {
            let squareSize = CGSize(width: .fallingBuddySize, height: .fallingBuddySize)
            let centerPoint = fallingPosition[idx]
            let frame = CGRect(origin: centerPoint, size: squareSize)
            let dropFace = BuddyView()
            dropFace.image = UIImage(named: fallingBuddys[idx])
            dropFace.frame = frame
            self.addSubview(dropFace)
            self.configureAnimation(face: dropFace)
        }
   }

    private func configureAnimation(face: UIImageView) {
        self.animator.addBehavior(self.gravity)
        self.animator.addBehavior(self.collider)
        self.animator.addBehavior(self.dynamicItemBehavior)
        self.collider.addItem(face)
        self.gravity.addItem(face)
        self.dynamicItemBehavior.addItem(face)
    }

    private func appNameAnimation() {
        self.viewExpand(duration: 0.7)
    }
    
    private func viewExpand(duration: CGFloat) {
        if duration < 0.5 {
            self.titleTransitionAnimation(duration: duration)
        } else {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.titleLabel.transform = CGAffineTransform(scaleX: CGFloat(duration * 2.5), y: CGFloat(duration * 2.5))
            } completion: { [weak self] _ in
                self?.viewIdentity(duration: duration - 0.1)
            }
        }
    }
    
    private func viewIdentity(duration: CGFloat) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.titleLabel.transform = CGAffineTransform.identity
        } completion: { [weak self] _ in
            self?.viewExpand(duration: duration)
        }
    }
    
    private func titleTransitionAnimation(duration: CGFloat) {
        UIView.animate(withDuration: duration * 2) { [weak self] in
            self?.titleLabel.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height * 0.17))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: duration) {
                self?.alpha = 0
            } completion: { [weak self] _ in
                self?.removeFromSuperview()
            }
        }
    }

}
