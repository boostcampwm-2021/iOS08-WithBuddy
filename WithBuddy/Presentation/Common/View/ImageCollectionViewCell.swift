//
//  ImageCollectionViewCell.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/17.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private var image = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func update(image: UIImage?, check: Bool) {
        self.backgroundColor = .backgroundPurple
        self.image.image = image
        if check {
            self.image.alpha = 1.0
        } else {
            self.image.alpha = 0.3
        }
    }

    private func configure() {
        self.addSubview(self.image)
        self.image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.image.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
}
