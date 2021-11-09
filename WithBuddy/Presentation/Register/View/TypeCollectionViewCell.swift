//
//  TypeCollectionViewCell.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/07.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    static let identifer = "TypeCollectionViewCell"
    
    private var image = UIImageView()
    private var textLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func configure(image: UIImage?, text: String) {
        guard let image = image else {
            return
        }
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

