//
//  ImageTextCollectionViewCell.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/02.
//

import UIKit

class ImageTextCollectionViewCell: UICollectionViewCell {
    static let identifer = "ImageTextCollectionViewCell"
    
    private var typeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "x.circle"))
        return imageView
    }()
    
    private var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.configureLayout()
    }
    
    private func configure() {
        self.addSubview(self.typeImage)
        self.addSubview(self.typeTitleLabel)
    }
    
    private func configureLayout() {
        self.typeImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.typeImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.typeImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.typeImage.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        self.typeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeTitleLabel.topAnchor.constraint(equalTo: self.typeImage.bottomAnchor, constant: 10),
            self.typeTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
}
