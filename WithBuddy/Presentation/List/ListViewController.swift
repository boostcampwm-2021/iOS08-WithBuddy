//
//  ListViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    
    private let listViewModel = ListViewModel()
    private let searchView = SearchView()
    private let listCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
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
            .sink { _ in
                self.listCollectionView.reloadData()
            }
            .store(in: &self.cancellables)
    }
    
    private func configureSearchView() {
        self.view.addSubview(self.searchView)
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
        self.listCollectionView.dataSource = self
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

}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        let gathering = self.listViewModel[indexPath.item]
        cell.update(date: gathering.date, buddyImageNames: gathering.buddyList.map{ $0.face }, typeImageNames: gathering.type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-40, height: 150)
    }

}
