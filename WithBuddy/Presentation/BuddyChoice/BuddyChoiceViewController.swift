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
    
    private func configureBuddyCollectionView() {
        self.view.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .vertical
        buddyFlowLayout.itemSize = CGSize(width: self.view.frame.width*0.2, height: self.view.frame.width*0.3)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.collectionViewDidTouched(_:)))
        self.buddyCollectionView.addGestureRecognizer(tap)
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 20),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.buddyCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func collectionViewDidTouched(_ sender: UITapGestureRecognizer) {
       if let indexPath = self.buddyCollectionView.indexPathForItem(at: sender.location(in: self.buddyCollectionView)) {
           self.buddyChoiceViewModel.buddyDidChecked(in: indexPath.item)
       }
    }
    
}

extension BuddyChoiceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
