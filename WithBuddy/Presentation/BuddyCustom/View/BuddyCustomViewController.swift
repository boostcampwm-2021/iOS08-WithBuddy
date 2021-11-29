//
//  BuddyCustomViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/10.
//

import UIKit
import Combine

class BuddyCustomViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private var nameTextField = UITextField()
    private var lineView = UIView()
    private var buddyImageView = UIImageView()
    
    private var colorTitleLabel = BlackTitleLabel()
    private var colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var colorDataSource = UICollectionViewDiffableDataSource<Int, CheckableInfo>(collectionView: self.colorCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CheckableInfo) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.engDescription), check: itemIdentifier.check)
        return cell
    }
    
    private var faceTitleLabel = BlackTitleLabel()
    private var faceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var faceDataSource = UICollectionViewDiffableDataSource<Int, CheckableInfo>(collectionView: self.faceCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CheckableInfo) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.engDescription), check: itemIdentifier.check)
        return cell
    }
    
    private var buddyCustomViewModel = BuddyCustomViewModel()
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: BuddyCustomDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPurple
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.completeCustom))
        
        self.configure()
        self.bind()
        self.navigationController?.navigationBar.topItem?.title = "Back"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelPurple as Any]
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.topItem?.title = "Back"
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            guard let text = textField.text else { return }
            
            if text.count > 10 {
                let index = text.index(text.startIndex, offsetBy: 10)
                let newString = String(text[..<index])
                textField.text = newString
                textField.resignFirstResponder()
            }
        }
    }
    
    func configure(by buddy: Buddy) {
        self.buddyCustomViewModel.buddyDidInserted(buddy)
    }
    
    private func bind() {
        self.buddyCustomViewModel.$face
            .receive(on: DispatchQueue.main)
            .sink { [weak self] face in
                var colorSnapshot = NSDiffableDataSourceSnapshot<Int, CheckableInfo>()
                colorSnapshot.appendSections([0])
                colorSnapshot.appendItems(FaceColor.allCases.map({
                    CheckableInfo(engDescription: $0.description, korDescription: $0.description, check: $0 == face.color)
                }))
                self?.colorDataSource.apply(colorSnapshot, animatingDifferences: true)
                
                var faceSnapshot = NSDiffableDataSourceSnapshot<Int, CheckableInfo>()
                faceSnapshot.appendSections([0])
                faceSnapshot.appendItems((Int.minFaceNum...Int.maxFaceNum).map({
                    CheckableInfo(engDescription: "\(face.color)\($0)", korDescription: "\(face.color)\($0)", check: $0 == face.number)
                }))
                self?.faceDataSource.apply(faceSnapshot, animatingDifferences: true)
                
                self?.buddyImageView.image = UIImage(named: "\(face)")
            }
            .store(in: &self.cancellables)
        
        self.buddyCustomViewModel.$name
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] text in
                self?.nameTextField.text = text
            }
            .store(in: &self.cancellables)
        
        self.buddyCustomViewModel.addDoneSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] buddy in
                self?.delegate?.buddyAddDidCompleted(buddy)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyCustomViewModel.editDoneSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] buddy in
                self?.delegate?.buddyEditDidCompleted(buddy)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyCustomViewModel.failSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                self?.alertError(result)
            }
            .store(in: &self.cancellables)
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
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapEmptySpace)))
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
        if let color = UIColor.labelPurple {
            self.nameTextField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
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
        self.colorCollectionView.backgroundColor = .clear
        self.colorCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.colorCollectionViewDidTouched(_:)))
        self.colorCollectionView.addGestureRecognizer(tap)
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = (self.view.frame.width - (.plusInset * 2))/6 - .innerPartInset
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.scrollDirection = .horizontal
        self.colorCollectionView.collectionViewLayout = flowLayout
        
        self.colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorCollectionView.topAnchor.constraint(equalTo: self.colorTitleLabel.bottomAnchor, constant: 10),
            self.colorCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.colorCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.colorCollectionView.heightAnchor.constraint(equalToConstant: width)
        ])
    }
    
    @objc func colorCollectionViewDidTouched(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.colorCollectionView.indexPathForItem(at: sender.location(in: self.colorCollectionView)) {
            self.buddyCustomViewModel.colorDidChosen(in: indexPath.item)
            self.view.endEditing(true)
        }
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
        self.faceCollectionView.backgroundColor = .clear
        self.faceCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.faceCollectionViewDidTouched(_:)))
        self.faceCollectionView.addGestureRecognizer(tap)
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = (self.view.frame.width - (.plusInset * 2))/5 - .innerPartInset
        let totalHeight = width*3 + 20
        flowLayout.itemSize = CGSize(width: width, height: width)
        self.faceCollectionView.collectionViewLayout = flowLayout
        
        self.faceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.faceCollectionView.topAnchor.constraint(equalTo: self.faceTitleLabel.bottomAnchor, constant: 10),
            self.faceCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.faceCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.faceCollectionView.heightAnchor.constraint(equalToConstant: totalHeight),
            self.faceCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    @objc func faceCollectionViewDidTouched(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.faceCollectionView.indexPathForItem(at: sender.location(in: self.faceCollectionView)) {
            self.buddyCustomViewModel.faceDidChosen(in: indexPath.item)
            self.view.endEditing(true)
        }
    }
    
    private func alertError(_ error: BuddyCustomError) {
        let alert = UIAlertController(title: "추가 실패", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func completeCustom() {
        self.buddyCustomViewModel.didDoneTouched()
    }
    
    @objc private func tapEmptySpace(){
        self.nameTextField.resignFirstResponder()
    }
    
}

extension BuddyCustomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.buddyCustomViewModel.nameDidChaged(name: text)
    }
    
}

protocol BuddyCustomDelegate: AnyObject {
    func buddyAddDidCompleted(_: Buddy)
    func buddyEditDidCompleted(_: Buddy)
}
