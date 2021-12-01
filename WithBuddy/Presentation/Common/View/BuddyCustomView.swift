//
//  BuddyCustomView.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/12/01.
//

import UIKit

class BuddyCustomView: UIScrollView {

    private lazy var contentView = UIView()
    
    private(set) lazy var nameTextField = UITextField()
    private lazy var lineView = UIView()
    private(set) lazy var buddyImageView = UIImageView()
    
    private lazy var colorTitleLabel = BlackTitleLabel()
    private(set) lazy var colorCollectionView = ColorCollectionView()
    
    private lazy var faceTitleLabel = BlackTitleLabel()
    private(set) lazy var faceCollectionView = FaceCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func configure() {
        self.configureContentView()
        self.configureNameTextField()
        self.configureLineView()
        self.configureMyBuddyImageView()
        self.configureColorTitleLabel()
        self.configureColorCollectionView()
        self.configureFaceTitleLabel()
        self.configureFaceCollectionView()
    }
    
    private func configureContentView() {
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func configureNameTextField() {
        self.contentView.addSubview(self.nameTextField)
        if let color = UIColor.labelPurple {
            self.nameTextField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
        self.nameTextField.textAlignment = .center
        
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.nameTextField.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    private func configureLineView() {
        self.contentView.addSubview(self.lineView)
        self.lineView.backgroundColor = .labelPurple
        
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lineView.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 5),
            self.lineView.leadingAnchor.constraint(equalTo: self.nameTextField.leadingAnchor),
            self.lineView.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor),
            self.lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureMyBuddyImageView() {
        self.contentView.addSubview(self.buddyImageView)
        
        self.buddyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyImageView.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 10),
            self.buddyImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.buddyImageView.widthAnchor.constraint(equalToConstant: 250),
            self.buddyImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func configureColorTitleLabel() {
        self.contentView.addSubview(self.colorTitleLabel)
        self.colorTitleLabel.text = "색상"
        
        self.colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorTitleLabel.topAnchor.constraint(equalTo: self.buddyImageView.bottomAnchor, constant: 20),
            self.colorTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureColorCollectionView() {
        self.contentView.addSubview(self.colorCollectionView)
        
        self.colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorCollectionView.topAnchor.constraint(equalTo: self.colorTitleLabel.bottomAnchor, constant: 10),
            self.colorCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.colorCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.colorCollectionView.heightAnchor.constraint(equalTo: self.colorCollectionView.widthAnchor, multiplier: CGFloat(1.0/6.0))
        ])
    }
    
    private func configureFaceTitleLabel() {
        self.contentView.addSubview(self.faceTitleLabel)
        self.faceTitleLabel.text = "얼굴"
        
        self.faceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.faceTitleLabel.topAnchor.constraint(equalTo: self.colorCollectionView.bottomAnchor, constant: 20),
            self.faceTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureFaceCollectionView() {
        self.contentView.addSubview(self.faceCollectionView)
        
        self.faceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.faceCollectionView.topAnchor.constraint(equalTo: self.faceTitleLabel.bottomAnchor, constant: 10),
            self.faceCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.faceCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.faceCollectionView.heightAnchor.constraint(equalTo: self.faceCollectionView.widthAnchor, multiplier: 3.0/5.0),
            self.faceCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
}
