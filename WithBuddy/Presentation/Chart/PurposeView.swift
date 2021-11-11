//
//  PurposeView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class PurposeView: UIView {
    
    private let imageView = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.configureImageView()
        self.configureLabel()
    }
    
    private func configureImageView() {
        self.addSubview(self.imageView)
        self.imageView.image = UIImage(systemName: "photo")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 65),
            self.imageView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func configureLabel() {
        self.addSubview(self.label)
        self.label.text = "버디"
        self.label.font = .systemFont(ofSize: 12)
        self.label.textAlignment = .center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 4),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
