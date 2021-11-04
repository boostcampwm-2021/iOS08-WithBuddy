//
//  ListCollectionViewCell.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "listCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
    }
    
}
