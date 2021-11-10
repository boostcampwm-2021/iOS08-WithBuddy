//
//  BuddyChoiceViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import UIKit
import Combine

class BuddyChoiceViewController: UIViewController {
    
    private let searchView = SearchView()
    private let addButton = UIButton()
    private let buddyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var buddyChoiceViewModel = BuddyChoiceViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.face), text: itemIdentifier.name, check: itemIdentifier.check)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
        self.buddyChoiceViewModel.buddyDidUpdated([Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"),
                                                   Buddy(id: UUID(), name: "TEST", face: "FaceBlue1")])
    }
    
    private func bind() {
        self.buddyChoiceViewModel.$storedBuddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                snapshot.appendSections([0])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.configureSearchView()
        self.configureButton()
        self.configureBuddyCollectionView()
    }
    
    private func configureSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.searchTextField.delegate = self
        self.searchView.layer.cornerRadius = 10
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureButton() {
        self.view.addSubview(self.addButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 60, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        self.addButton.setImage(image, for: .normal)
        self.addButton.addTarget(self, action: #selector(self.onAddButtonTouched(_:)), for: .touchUpInside)
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 10),
            self.addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureBuddyCollectionView() {
        self.view.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        self.buddyCollectionView.delegate = self
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .vertical
        buddyFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 10),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.buddyCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func onAddButtonTouched(_ sender: UIButton) {
        self.buddyChoiceViewModel.buddyDidAdded(Buddy(id: UUID(), name: "TEST", face: "FaceBlue1"))
        self.navigationController?.pushViewController(BuddyCustomViewController(), animated: true)
    }
    
}

extension BuddyChoiceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension BuddyChoiceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.buddyChoiceViewModel.buddyDidChecked(in: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let edit = UIAction(title: NSLocalizedString("편집", comment: ""),
                                  image: UIImage(systemName: "pencil.circle")) { action in
//                self.delegate?.buddyDidDeleted(indexPath.item)
            }
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                  image: UIImage(systemName: "trash")) { action in
                self.buddyChoiceViewModel.buddyDidADeleted(in: indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [edit, delete])
        })
    }
    
}
