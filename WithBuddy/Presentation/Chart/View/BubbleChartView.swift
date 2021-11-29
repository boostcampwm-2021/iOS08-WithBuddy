//
//  BubbleChartView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class BubbleChartView: UIView {
    
    private let titleLabel = PurpleTitleLabel()
    private let whiteView = WhiteView()
    private let firstBubbleImageView = UIImageView()
    private let secondBubbleImageView = UIImageView()
    private let thirdBubbleImageView = UIImageView()
    private let fourthBubbleImageView = UIImageView()
    private let fifthBubbleImageView = UIImageView()
    private let bubbleDescriptionView = BubbleDescriptionView()
    private let defaultView = DefaultView()
    
    private let maxLength = CGFloat.chartBubbleMaxLength
    private var maxCount: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func update(list: [(Buddy, Int)]) {
        let first = list.indices ~= 0 ? list[0] : nil
        let second = list.indices ~= 1 ? list[1] : nil
        let third = list.indices ~= 2 ? list[2] : nil
        let fourth = list.indices ~= 3 ? list[3] : nil
        let fifth = list.indices ~= 4 ? list[4] : nil
        
        if first == nil {
            self.defaultView.isHidden = false
            self.firstBubbleImageView.isHidden = true
            return
        }
        
        let constant = CGFloat(1)
        self.defaultView.isHidden = true
        self.maxCount = first?.1
        self.update(imageView: self.firstBubbleImageView, face: first?.0.face, count: 0, xValue: 0, yValue: 0)
        self.update(imageView: self.secondBubbleImageView, face: second?.0.face, count: second?.1, xValue: -constant, yValue: -constant)
        self.update(imageView: self.thirdBubbleImageView, face: third?.0.face, count: third?.1, xValue: constant, yValue: constant)
        self.update(imageView: self.fourthBubbleImageView, face: fourth?.0.face, count: fourth?.1, xValue: -constant, yValue: constant)
        self.update(imageView: self.fifthBubbleImageView, face: fifth?.0.face, count: fifth?.1, xValue: constant, yValue: -constant)
    }
    
    func resetBubbles() {
        self.firstBubbleImageView.frame.size = CGSize.zero
        self.secondBubbleImageView.frame.size = CGSize.zero
        self.thirdBubbleImageView.frame.size = CGSize.zero
        self.fourthBubbleImageView.frame.size = CGSize.zero
        self.fifthBubbleImageView.frame.size = CGSize.zero
    }
    
    private func update(imageView: UIImageView, face: String?, count: Int?, xValue: CGFloat, yValue: CGFloat) {
        if let face = face, let count = count, let maxCount = self.maxCount {
            imageView.image = UIImage(named: face)
            imageView.isHidden = false
            if imageView != self.firstBubbleImageView {
                let bubbleLength = (self.maxLength / 2) * (1 + (CGFloat(count) / CGFloat(maxCount)))
                let firstFrame = self.firstBubbleImageView.frame
                let firstCenterX = firstFrame.origin.x + (firstFrame.width / 2)
                let firstCenterY = firstFrame.origin.y + (firstFrame.height / 2)
                let centerX = ((firstFrame.width / 4) + (bubbleLength / 4)) * xValue
                let centerY = ((firstFrame.height / 4) + (bubbleLength / 4)) * yValue
                imageView.frame.size = CGSize(width: 0, height: 0)
                imageView.center = CGPoint(x: firstCenterX + (centerX / 2), y: firstCenterY + (centerY / 2))
                UIView.animate(withDuration: 1) {
                    imageView.frame.size = CGSize(width: bubbleLength, height: bubbleLength)
                    imageView.center = CGPoint(x: firstCenterX + centerX, y: firstCenterY + centerY)
                }
            }
            return
        }
        imageView.isHidden = true
    }
    
    private func animateBubble(imageView: UIImageView, count: Int?, length: CGFloat) {
        UIView.animate(withDuration: 1) {
            imageView.frame.size = CGSize(width: length, height: length)
        }
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureWhiteView()
        self.configureChart()
        self.configureFirstBubble()
        self.configureBubbles()
        self.configureBubbleDescriptionView()
        self.configureDefaultView()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.text = .bubbleChartTitle
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    private func configureWhiteView() {
        self.addSubview(self.whiteView)
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whiteView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.whiteView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: .innerPartInset),
            self.whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.whiteView.heightAnchor.constraint(equalToConstant: .bubbleChartHeight),
            self.whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureChart() {
        self.defaultView.isHidden = true
        self.whiteView.addSubview(self.secondBubbleImageView)
        self.whiteView.addSubview(self.thirdBubbleImageView)
        self.whiteView.addSubview(self.fourthBubbleImageView)
        self.whiteView.addSubview(self.fifthBubbleImageView)
        self.whiteView.addSubview(self.firstBubbleImageView)
    }
    
    private func configureFirstBubble() {
        self.firstBubbleImageView.image = .defaultFaceImage
        self.firstBubbleImageView.isHidden =  true
        self.firstBubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBubbleImageView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.firstBubbleImageView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.firstBubbleImageView.widthAnchor.constraint(equalToConstant: self.maxLength),
            self.firstBubbleImageView.heightAnchor.constraint(equalToConstant: self.maxLength)
        ])
    }
    
    private func configureBubbles() {
        self.configureBubble(imageView: self.secondBubbleImageView)
        self.configureBubble(imageView: self.thirdBubbleImageView)
        self.configureBubble(imageView: self.fourthBubbleImageView)
        self.configureBubble(imageView: self.fifthBubbleImageView)
    }
    
    private func configureBubble(imageView: UIImageView) {
        imageView.isHidden = true
        imageView.frame.size = CGSize.zero
    }
    
    private func configureBubbleDescriptionView() {
        self.whiteView.addSubview(self.bubbleDescriptionView)
        self.bubbleDescriptionView.isHidden = true
        self.bubbleDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bubbleDescriptionView.leadingAnchor.constraint(equalTo: self.whiteView.leadingAnchor),
            self.bubbleDescriptionView.topAnchor.constraint(equalTo: self.whiteView.topAnchor),
            self.bubbleDescriptionView.trailingAnchor.constraint(equalTo: self.whiteView.trailingAnchor),
            self.bubbleDescriptionView.bottomAnchor.constraint(equalTo: self.whiteView.bottomAnchor)
        ])
    }
    
    private func configureDefaultView() {
        self.whiteView.addSubview(self.defaultView)
        self.defaultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.defaultView.centerXAnchor.constraint(equalTo: self.whiteView.centerXAnchor),
            self.defaultView.centerYAnchor.constraint(equalTo: self.whiteView.centerYAnchor),
            self.defaultView.widthAnchor.constraint(equalToConstant: .chartDefaultViewLength),
            self.defaultView.heightAnchor.constraint(equalToConstant: .chartDefaultViewLength)
        ])
    }

}
