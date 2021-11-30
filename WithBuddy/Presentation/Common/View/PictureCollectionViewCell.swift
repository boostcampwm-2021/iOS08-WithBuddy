//
//  PictureCollectionViewCell.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/02.
//

import UIKit

final class PictureCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PictureCollectionViewCell"
    private var photoImage = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func configure(url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        photoImage.image = UIImage(data: data)
    }
    
    private func configure() {
        self.addSubview(self.photoImage)
        self.backgroundColor = .backgroundPurple
        self.photoImage.contentMode = .scaleAspectFit
        self.photoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.photoImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.photoImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.photoImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.photoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
