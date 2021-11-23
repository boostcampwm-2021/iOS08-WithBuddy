//
//  LoadingViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/22.
//

import UIKit

class LoadingView: UIView {

    private var titleLabel = UILabel()
    private var lazyBehavior = UIDynamicItemBehavior()

    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()

    lazy var gravity: UIGravityBehavior = {
        let lazyGravity = UIGravityBehavior()
        lazyGravity.magnitude = 1
        return lazyGravity
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()
    
    lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        lazyBehavior.elasticity = 0.7
        lazyBehavior.allowsRotation = true
        lazyBehavior.density = 1.5
        return lazyBehavior
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    private func configure() {
        self.configureTitle()
        self.addFaces()
    }
    
    private func configureTitle() {
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "위드버디"
        self.animateBboing()
        self.titleLabel.font = UIFont(name: "Cafe24Ssurround", size: 60)
        self.titleLabel.textColor = .white
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 250),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(equalToConstant: self.titleLabel.intrinsicContentSize.width)
        ])
    }
    
    private func addFaces() {
        let fallingBuddys = ["FaceBlue1", "FaceGreen2", "FaceRed3", "FacePink4", "FaceYellow5"]
        let width = UIScreen.main.bounds.width
        let fallingPosition = [CGPoint(x: width * 0.2, y: 30), CGPoint(x: width * 0.3, y: 10), CGPoint(x: width * 0.45, y: 20), CGPoint(x: width * 0.6, y: 20), CGPoint(x: width * 0.7, y: 40)]
        
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
    
    private func animateBboing() {
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.titleLabel.transform = CGAffineTransform(scaleX: CGFloat(2), y: CGFloat(2))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.titleLabel.transform = CGAffineTransform.identity
            } completion: { [weak self] _ in
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.titleLabel.transform = CGAffineTransform(scaleX: CGFloat(1.5), y: CGFloat(1.5))
                } completion: { [weak self] _ in
                    UIView.animate(withDuration: 0.4) { [weak self] in
                        self?.titleLabel.transform = CGAffineTransform.identity
                    } completion: { [weak self] _ in
                        UIView.animate(withDuration: 0.4) { [weak self] in
                            self?.titleLabel.transform = CGAffineTransform(scaleX: CGFloat(1.2), y: CGFloat(1.2))
                        } completion: { [weak self] _ in
                            UIView.animate(withDuration: 0.3) { [weak self] in
                                self?.titleLabel.transform = CGAffineTransform.identity
                            } completion: { [weak self] _ in
                                UIView.animate(withDuration: 0.3) { [weak self] in
                                    self?.titleLabel.transform = CGAffineTransform(scaleX: CGFloat(1.1), y: CGFloat(1.1))
                                } completion: { [weak self] _ in
                                    UIView.animate(withDuration: 0.3) { [weak self] in
                                        self?.titleLabel.transform = CGAffineTransform.identity
                                    } completion: { [weak self] _ in
                                        UIView.animate(withDuration: 1, animations: {
                                            self?.alpha = 0
                                        }, completion: { _ in
                                            self?.removeFromSuperview()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
