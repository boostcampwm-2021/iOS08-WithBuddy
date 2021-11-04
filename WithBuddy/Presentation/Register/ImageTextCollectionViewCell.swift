//
//  ImageTextCollectionViewCell.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/02.
//

import UIKit

class ImageTextCollectionViewCell: UICollectionViewCell {
    static let identifer = "ImageTextCollectionViewCell"
    
    private var image: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "x.circle"))
        return imageView
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.image)
        self.addSubview(self.textLabel)
        self.configureLayout()
    }
    
    func configure(image: UIImage?, text: String) {
        guard let image = image else {
            return
        }
        self.image.image = image
        self.textLabel.text = text
    }
    
    private func configureLayout() {
        self.image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.image.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.image.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 10),
            self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.textLabel.widthAnchor.constraint(equalToConstant: self.frame.width)
        ])
    }
    
}
