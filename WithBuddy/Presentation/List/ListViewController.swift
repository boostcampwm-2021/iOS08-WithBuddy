//
//  ListViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    
    private let searchView = SearchView()
    private let listCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var listDataSource = UICollectionViewDiffableDataSource<Int, TmpGatheringList>(collectionView: self.listCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: TmpGatheringList) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        cell.update(date: itemIdentifier.date, buddyImageNames: itemIdentifier.buddyList.map{ $0.face }, typeImageNames: itemIdentifier.type)
        return cell
    }
    
    private let listViewModel = ListViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    private func configure() {
        self.configureSearchView()
        self.configureCollectionView()
    }
    
    private func bind() {
        self.listViewModel.$gatheringList
            .sink { [weak self] getheringList in
                self?.reloadGathering(list: getheringList)
            }
            .store(in: &self.cancellables)
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
    
    private func configureCollectionView() {
        self.view.addSubview(self.listCollectionView)
        self.listCollectionView.delegate = self
        self.listCollectionView.backgroundColor = .clear
        self.listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        self.listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.listCollectionView.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 20),
            self.listCollectionView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.listCollectionView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func reloadGathering(list: [TmpGatheringList]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TmpGatheringList>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        self.listDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-40, height: 150)
    }
    
}
