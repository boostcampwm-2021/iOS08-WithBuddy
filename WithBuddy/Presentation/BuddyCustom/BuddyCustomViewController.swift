//
//  BuddyCustomViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/10.
//

import UIKit

class BuddyCustomViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private var nameTextField = UITextField()
    private var lineView = UIView()
    private var buddyImageView = UIImageView()
    
    private var colorTitleLabel = TitleLabel()
    private var colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private var faceTitleLabel = TitleLabel()
    private var faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        
        self.configure()
    }
    
    private func configure() {
        self.configureScrollView()
        self.configureContentView()
        self.configureNameTextField()
        self.configureLineView()
        self.configureMyBuddyImageView()
        self.configureColorTitleLabel()
        self.configureColorCollectionView()
        self.configureFaceTitleLabel()
        self.configureFaceCollectionView()
    }
    
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureNameTextField() {
        self.contentView.addSubview(self.nameTextField)
        self.nameTextField.placeholder = "버디이름을 입력해주세요."
        self.nameTextField.delegate = self
        self.nameTextField.textAlignment = .center
        
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.nameTextField.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    private func configureLineView() {
        self.contentView.addSubview(self.lineView)
        self.lineView.backgroundColor = UIColor(named: "LabelPurple")
        
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
        self.buddyImageView.image = UIImage(named: "FaceBlue1")
        
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
        self.colorCollectionView.backgroundColor = .blue
        
        self.colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorCollectionView.topAnchor.constraint(equalTo: self.colorTitleLabel.bottomAnchor, constant: 10),
            self.colorCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.colorCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.colorCollectionView.heightAnchor.constraint(equalToConstant: 60)
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
        self.faceCollectionView.backgroundColor = .blue
        
        self.faceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.faceCollectionView.topAnchor.constraint(equalTo: self.faceTitleLabel.bottomAnchor, constant: 10),
            self.faceCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.faceCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.faceCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
}

extension BuddyCustomViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
             let isBackSpace = strcmp(char, "\\b")
             if isBackSpace == -92 {
                 return true
             }
         }
        guard let text = textField.text else { return true }
        return text.count < 10
    }
}
