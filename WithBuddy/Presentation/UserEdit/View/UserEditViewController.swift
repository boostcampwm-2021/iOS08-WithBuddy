//
//  UserEditViewController.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/12/01.
//

import UIKit
import Combine

final class UserEditViewController: UIViewController {

    private lazy var buddyCustomView = BuddyCustomView()
    private lazy var colorDataSource = UICollectionViewDiffableDataSource<Int, CheckableInfo>(collectionView: self.buddyCustomView.colorCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CheckableInfo) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.engDescription), check: itemIdentifier.check)
        return cell
    }
    private lazy var faceDataSource = UICollectionViewDiffableDataSource<Int, CheckableInfo>(collectionView: self.buddyCustomView.faceCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CheckableInfo) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.engDescription), check: itemIdentifier.check)
        return cell
    }
    
    private var userEditViewModel = UserEditViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPurple
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.didDoneTouched))
        self.configure()
        self.bind()
        self.userEditViewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didTextChanged), name: UITextField.textDidChangeNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    @objc private func didTextChanged() {
        if let text = self.buddyCustomView.nameTextField.text {
            if text.count > 10 {
                let index = text.index(text.startIndex, offsetBy: 10)
                self.buddyCustomView.nameTextField.text = String(text[..<index])
                self.buddyCustomView.nameTextField.resignFirstResponder()
            }
        }
    }
    
    private func bind() {
        self.userEditViewModel.$face
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
                
                self?.buddyCustomView.buddyImageView.image = UIImage(named: "\(face)")
            }
            .store(in: &self.cancellables)
        
        self.userEditViewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.buddyCustomView.nameTextField.text = text
            }
            .store(in: &self.cancellables)
        
        self.userEditViewModel.editDoneSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellables)
        
        self.userEditViewModel.failSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.alertError(result)
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.view.addSubview(self.buddyCustomView)
        
        buddyCustomView.nameTextField.delegate = self
        buddyCustomView.colorCollectionView.delegate = self
        buddyCustomView.faceCollectionView.delegate = self
        self.buddyCustomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCustomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.buddyCustomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.buddyCustomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.buddyCustomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
    private func alertError(_ error: BuddyCustomError) {
        let alert = UIAlertController(title: "캐릭터 설정 실패", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didDoneTouched() {
        self.userEditViewModel.didDoneTouched()
    }
    
}

extension UserEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.userEditViewModel.didNameChaged(name: text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count >= 10 && range.length == 0 && range.location < 10 {
            return false
        }
        return true
    }

}

extension UserEditViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if collectionView == self.buddyCustomView.colorCollectionView {
            self.userEditViewModel.didColorChosend(in: indexPath.item)
        } else {
            self.userEditViewModel.didFaceChosen(in: indexPath.item)
        }
    }
    
}

