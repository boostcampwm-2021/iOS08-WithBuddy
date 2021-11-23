//
//  LoadingViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/22.
//

import UIKit

class LoadingView: UIView {

    private var titleLabel = UILabel()
    private var loadingView = UIView()
    let lazyBehavior = UIDynamicItemBehavior()

    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.loadingView)
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
    
    override init() {
        super.init()
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    private func configure() {
        self.configureBackground()
        self.configureTitle()
        self.addFaces()
    }
    
    func configureBackground() {
        self.addSubview(self.loadingView)
        self.backgroundColor = UIColor(named: "GraphPurple2")
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            self.loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loadingView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureTitle() {
        self.loadingView.addSubview(self.titleLabel)
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
    
    func addFaces() {
        let fallingBuddys = ["FaceBlue1", "FaceGreen2", "FaceRed3", "FacePink4", "FaceYellow5"]
        let width = self.bounds.width
        let fallingPosition = [CGPoint(x: width * 0.3, y: 20), CGPoint(x: width * 0.4, y: 15), CGPoint(x: width * 0.7, y: 20), CGPoint(x: width * 0.4, y: -10), CGPoint(x: width * 0.6, y: -10)]
        
        for idx in 0..<fallingBuddys.count {
            let squareSize = CGSize(width: .fallingBuddySize, height: .fallingBuddySize)
            let centerPoint = fallingPosition[idx]
            let frame = CGRect(origin: centerPoint, size: squareSize)
            let dropFace = BuddyView()
            dropFace.image = UIImage(named: fallingBuddys[idx])
            dropFace.frame = frame
            self.loadingView.addSubview(dropFace)
            self.configureAnimation(face: dropFace)
        }
   }
    
    func configureAnimation(face: UIImageView) {
        self.animator.addBehavior(self.gravity)
        self.animator.addBehavior(self.collider)
        self.animator.addBehavior(self.dynamicItemBehavior)
        self.collider.addItem(face)
        self.gravity.addItem(face)
        self.dynamicItemBehavior.addItem(face)
    }
    
    func animateBboing() {
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
                                        self?.removeFromSuperview()
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
