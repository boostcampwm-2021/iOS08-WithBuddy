//
//  RegisterViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/01.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private var registerViewModel = RegisterViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var pictureDataSource: UICollectionViewDiffableDataSource<Int, URL> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: self.pictureCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: URL) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifer, for: indexPath) as? PictureCollectionViewCell else { preconditionFailure() }
            cell.configure(url: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    
    private lazy var typeDataSource: UICollectionViewDiffableDataSource<Int, PlaceType> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, PlaceType>(collectionView: self.typeCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: PlaceType) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifer, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
            cell.configure(image: UIImage(named: "FaceRed"), text: itemIdentifier.rawValue)
            return cell
        }
        return dataSource
    }()
    
    private lazy var buddyDataSource: UICollectionViewDiffableDataSource<Int, Buddy> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifer, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
            cell.configure(image: UIImage(named: "Purple1"), text: itemIdentifier.name)
            return cell
        }
        return dataSource
    }()
    
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.backgroundColor = .white
        return datePicker
    }()
        
    private lazy var toolBar : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneClicked))]
        toolBar.sizeToFit()
        return toolBar
    }()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEmptySpace(sender:))))
        return view
    }()
    
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 날짜"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var placeLTitleabel: UILabel = {
        let label = UILabel()
        label.text = "모임 장소"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 목적"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var buddyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "만난 버디"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var memoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var memoTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        guard let color = UIColor(named: "LabelPurple") else {
            return textField
        }
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: "간단한 메모를 남겨보아요", attributes: [NSAttributedString.Key.foregroundColor : color])
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var pictureTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.textColor = UIColor(named: "LabelPurple")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var dateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var dateLabel = UILabel()
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.onDateButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        guard let color = UIColor(named: "LabelPurple") else {
            return textField
        }
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: "장소를 적어주세요", attributes: [NSAttributedString.Key.foregroundColor : color])
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var typeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var buddyAddButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 60, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.onBuddyAddButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var pictureAddButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.square", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.onPictureButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buddyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pictureCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureLayout()
        self.configureCollectionView()
        self.bind()
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.dateTitleLabel)
        self.contentView.addSubview(self.dateBackgroundView)
        self.contentView.addSubview(self.placeLTitleabel)
        self.contentView.addSubview(self.placeBackgroundView)
        self.contentView.addSubview(self.typeTitleLabel)
        self.contentView.addSubview(self.typeCollectionView)
        self.contentView.addSubview(self.buddyTitleLabel)
        self.contentView.addSubview(self.buddyAddButton)
        self.contentView.addSubview(self.buddyCollectionView)
        self.contentView.addSubview(self.memoTitleLabel)
        self.contentView.addSubview(self.memoBackgroundView)
        self.contentView.addSubview(self.pictureTitleLabel)
        self.contentView.addSubview(self.pictureAddButton)
        self.contentView.addSubview(self.pictureCollectionView)
        
        self.dateBackgroundView.addSubview(self.dateLabel)
        self.dateBackgroundView.addSubview(self.dateButton)
        
        self.placeBackgroundView.addSubview(self.placeTextField)
        
        self.memoBackgroundView.addSubview(self.memoTextField)
    }
    
    private func configureCollectionView() {
        self.typeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifer)
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifer)
        self.pictureCollectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifer)
        
        let typeFlowLayout = UICollectionViewFlowLayout()
        typeFlowLayout.scrollDirection = .horizontal
        typeFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.typeCollectionView.collectionViewLayout = typeFlowLayout
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .horizontal
        buddyFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
        let pictureFlowLayout = UICollectionViewFlowLayout()
        pictureFlowLayout.scrollDirection = .horizontal
        pictureFlowLayout.itemSize = CGSize(width: self.view.frame.width-40, height: self.view.frame.width-40)
        self.pictureCollectionView.collectionViewLayout = pictureFlowLayout
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, PlaceType>()
        snapshot.appendSections([0])
        snapshot.appendItems(PlaceType.allCases)
        self.typeDataSource.apply(snapshot, animatingDifferences: true)
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
        
        self.configureDateLayout()
        self.configurePlaceLayout()
        self.configureTypeLayout()
        self.configureBuddyLayout()
        self.configureMemoLayout()
        self.configurePictureLayout()
    }
    
    private func configureDateLayout() {
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
    }
    
    private func configurePlaceLayout() {
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
    }
    
    private func configureTypeLayout() {
        self.typeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeTitleLabel.topAnchor.constraint(equalTo: self.placeTextField.bottomAnchor, constant: 40),
            self.typeTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeCollectionView.topAnchor.constraint(equalTo: self.typeTitleLabel.bottomAnchor, constant: 20),
            self.typeCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.typeCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.typeCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureBuddyLayout() {
        self.buddyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyTitleLabel.topAnchor.constraint(equalTo: self.typeCollectionView.bottomAnchor, constant: 40),
            self.buddyTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.buddyAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyAddButton.topAnchor.constraint(equalTo: self.buddyTitleLabel.bottomAnchor, constant: 20),
            self.buddyAddButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.buddyAddButton.widthAnchor.constraint(equalToConstant: 60),
            self.buddyAddButton.heightAnchor.constraint(equalTo: self.buddyAddButton.widthAnchor)
        ])
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.buddyAddButton.topAnchor),
            self.buddyCollectionView.leftAnchor.constraint(equalTo: self.buddyAddButton.rightAnchor, constant: 10),
            self.buddyCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.buddyCollectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureMemoLayout() {
        self.memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTitleLabel.topAnchor.constraint(equalTo: self.buddyCollectionView.bottomAnchor, constant: 40),
            self.memoTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.memoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoBackgroundView.topAnchor.constraint(equalTo: self.memoTitleLabel.bottomAnchor, constant: 20),
            self.memoBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.memoBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.memoBackgroundView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        self.memoTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTextField.topAnchor.constraint(equalTo: self.memoBackgroundView.topAnchor),
            self.memoTextField.leftAnchor.constraint(equalTo: self.memoBackgroundView.leftAnchor, constant: 20),
            self.memoTextField.rightAnchor.constraint(equalTo: self.memoBackgroundView.rightAnchor, constant: -20),
            self.memoTextField.bottomAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor)
        ])
    }
    
    private func configurePictureLayout() {
        self.pictureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureTitleLabel.topAnchor.constraint(equalTo: self.memoBackgroundView.bottomAnchor, constant: 40),
            self.pictureTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20)
        ])
        
        self.pictureAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureAddButton.centerYAnchor.constraint(equalTo: self.pictureTitleLabel.centerYAnchor),
            self.pictureAddButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.pictureAddButton.widthAnchor.constraint(equalToConstant: 30),
            self.pictureAddButton.heightAnchor.constraint(equalTo: self.pictureAddButton.widthAnchor)
        ])
        
        self.pictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureCollectionView.topAnchor.constraint(equalTo: self.pictureTitleLabel.bottomAnchor, constant: 20),
            self.pictureCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.pictureCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.pictureCollectionView.heightAnchor.constraint(equalTo: self.pictureCollectionView.widthAnchor),
            self.pictureCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    @objc private func onDateButtonClicked(_ sender: UIButton) {
        self.view.addSubview(self.datePicker)
        self.view.addSubview(self.toolBar)
                
        NSLayoutConstraint.activate([
            self.datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.datePicker.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            self.toolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor),
            self.toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bind() {
        self.registerViewModel.$date
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.dateLabel.text = date
            }
            .store(in: &self.cancellables)
        
        self.registerViewModel.$pictures
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pictures in
                var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
                
                snapshot.appendSections([0])
                snapshot.appendItems(pictures)
                self?.pictureDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
        
        self.registerViewModel.$buddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                
                snapshot.appendSections([0])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    @objc private func onPictureButtonClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    @objc private func onBuddyAddButtonClicked(_ sender: UIButton) {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let random = (0..<5).map{ _ in str.randomElement()! }
        self.registerViewModel.didBuddySelected(Buddy(name: String(random)))
    }
    
    @objc private func onDoneClicked() {
        self.registerViewModel.didDatePicked(self.datePicker.date)
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }

    @objc func tapEmptySpace(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }
        self.registerViewModel.didPicturePicked(url)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
