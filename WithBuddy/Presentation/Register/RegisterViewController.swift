//
//  RegisterViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 날짜"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var placeLTitleabel: UILabel = {
        let label = UILabel()
        label.text = "모임 장소"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 목적"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var buddyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "만난 버디"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var pictureTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var dateLabel = UILabel()
    private var dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    private var placeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var placeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "LabelPurple")
        textField.attributedPlaceholder = NSAttributedString(string: "장소를 적어주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "LabelPurple")])
        textField.backgroundColor = .systemBackground
        
        return textField
    }()
    
    private var typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.dateLabel)
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.configureUI()
        self.configureLayout()
        self.configureTypeCollectionView()
    }
    
    private func configureUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.dateTitleLabel)
        self.contentView.addSubview(self.dateBackgroundView)
        self.contentView.addSubview(self.placeLTitleabel)
        self.contentView.addSubview(self.placeBackgroundView)
        self.contentView.addSubview(self.typeTitleLabel)
        self.contentView.addSubview(self.typeCollectionView)
        
        self.dateBackgroundView.addSubview(self.dateLabel)
        self.dateBackgroundView.addSubview(self.dateButton)
        
        self.placeBackgroundView.addSubview(self.placeTextField)
    }
    
    private func configureTypeCollectionView() {
        self.typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: TypeCollectionViewCell.identifer)
        self.typeCollectionView.dataSource = self
        self.typeCollectionView.delegate = self
    }
    
    private func configureLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        self.dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            self.dateTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.dateBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.dateBackgroundView.topAnchor.constraint(equalTo: self.dateTitleLabel.bottomAnchor, constant: 10),
            self.dateBackgroundView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dateLabel.leftAnchor.constraint(equalTo: self.dateBackgroundView.leftAnchor, constant: 20),
            self.dateLabel.centerYAnchor.constraint(equalTo: self.dateBackgroundView.centerYAnchor),
            self.dateButton.rightAnchor.constraint(equalTo: self.dateBackgroundView.rightAnchor, constant: -20),
            self.dateButton.centerYAnchor.constraint(equalTo: self.dateBackgroundView.centerYAnchor)
        ])
        
        self.placeLTitleabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeLTitleabel.topAnchor.constraint(equalTo: self.dateBackgroundView.bottomAnchor, constant: 40),
            self.placeLTitleabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.placeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.placeBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.placeBackgroundView.topAnchor.constraint(equalTo: self.placeLTitleabel.bottomAnchor, constant: 10),
            self.placeBackgroundView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        self.placeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.placeTextField.leftAnchor.constraint(equalTo: self.placeBackgroundView.leftAnchor, constant: 20),
            self.placeTextField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.placeTextField.topAnchor.constraint(equalTo: self.placeBackgroundView.topAnchor),
            self.placeTextField.bottomAnchor.constraint(equalTo: self.placeBackgroundView.bottomAnchor)
        ])
        
        self.typeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeTitleLabel.topAnchor.constraint(equalTo: self.placeTextField.bottomAnchor, constant: 40),
            self.typeTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.typeTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
        
        self.typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeCollectionView.topAnchor.constraint(equalTo: self.typeTitleLabel.bottomAnchor, constant: 20),
            self.typeCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.typeCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.typeCollectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
}

extension RegisterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.typeCollectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.identifer, for: indexPath) as? TypeCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: self.typeCollectionView.frame.height)
    }
    
}
