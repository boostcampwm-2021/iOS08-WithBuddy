//
//  ImageTextCollectionViewCell.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/02.
//

import UIKit

class ImageTextCollectionViewCell: UICollectionViewCell {
    static let identifer = "ImageTextCollectionViewCell"
    
    private var image = UIImageView()
    private var textLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func update(image: UIImage?, text: String, check: Bool?) {
        guard let image = image else {
            return
        }
        self.backgroundColor = UIColor(named: "BackgroundPurple")
        self.image.image = image
        self.textLabel.text = text
        if let check = check,
           check {
            self.image.alpha = 1.0
        } else {
            self.image.alpha = 0.3
        }
    }
    
    func update(image: UIImage?, text: String) {
        guard let image = image else {
            return
        }
        self.backgroundColor = UIColor(named: "BackgroundPurple")
        self.image.image = image
        self.textLabel.text = text
    }
    
    private func configure() {
        self.configureImage()
        self.configureTextLabel()
    }
    
    private func configureImage() {
        self.addSubview(self.image)
        self.image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.image.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.image.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func configureTextLabel() {
        self.addSubview(self.textLabel)
        self.textLabel.font = .systemFont(ofSize: 12)
        self.textLabel.textAlignment = .center
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 10),
            self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.textLabel.widthAnchor.constraint(equalToConstant: self.frame.width)
        ])
    }
    
}
