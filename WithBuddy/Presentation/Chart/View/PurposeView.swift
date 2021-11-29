//
//  PurposeView.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/11.
//

import UIKit

final class PurposeView: UIView {
    
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let rankLabel = PurpleLabel()
    private let purposeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func update(rank: Int, image: String, purpose: String) {
        self.rankLabel.text = "\(rank)"
        self.imageView.image = UIImage(named: image)
        self.purposeLabel.text = purpose
    }
    
    private func configure() {
        self.configureImageView()
        self.configureStackView()
        self.configureRankLabel()
        self.configurePurposeLabel()
    }
    
    private func configureImageView() {
        self.addSubview(self.imageView)
        self.imageView.image = .defaultFaceImage
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: .purposeImageSize),
            self.imageView.heightAnchor.constraint(equalToConstant: .purposeImageSize)
        ])
    }
    
    private func configureStackView() {
        self.addSubview(self.stackView)
        self.stackView.spacing = .purposeSpacing
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: .purposeSpacing),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureRankLabel() {
        self.stackView.addArrangedSubview(self.rankLabel)
        self.rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.rankLabel.widthAnchor.constraint(equalToConstant: .innerPartInset)
        ])
    }
    
    private func configurePurposeLabel() {
        self.stackView.addArrangedSubview(self.purposeLabel)
        self.purposeLabel.font = .systemFont(ofSize: .chartLabelSize)
        self.purposeLabel.textAlignment = .center
    }

}
