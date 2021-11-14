//
//  BuddySelectView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class BuddySelectView: UIView {
    
    private lazy var buddyAddButton = UIButton()
    private lazy var buddyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.face), text: itemIdentifier.name)
        return cell
    }
    
    weak var delegate: BuddyViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func buddyListReload(_ buddyList: [Buddy]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
        if buddyList.isEmpty {
            snapshot.appendSections([0])
            snapshot.appendItems([Buddy(id: UUID(), name: "친구없음", face: "FacePurple1")])
        } else {
            snapshot.appendSections([0])
            snapshot.appendItems(buddyList)
        }
        self.buddyDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure() {
        self.configureButton()
        self.configureCollectionView()
    }
    
    private func configureButton() {
        self.addSubview(self.buddyAddButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 60, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        self.buddyAddButton.setImage(image, for: .normal)
        self.buddyAddButton.addTarget(self, action: #selector(self.onBuddyAddButtonTouched(_:)), for: .touchUpInside)
        
        self.buddyAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyAddButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.buddyAddButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.buddyAddButton.widthAnchor.constraint(equalToConstant: 60),
            self.buddyAddButton.heightAnchor.constraint(equalTo: self.buddyAddButton.widthAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.showsHorizontalScrollIndicator = false
        self.buddyCollectionView.delegate = self
        
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 90)
        
        self.buddyCollectionView.collectionViewLayout = layout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.buddyAddButton.topAnchor),
            self.buddyCollectionView.leftAnchor.constraint(equalTo: self.buddyAddButton.rightAnchor, constant: 10),
            self.buddyCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.buddyCollectionView.heightAnchor.constraint(equalToConstant: 90),
            self.buddyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func onBuddyAddButtonTouched(_ sender: UIButton) {
        self.delegate?.buddyAddDidTouched()
    }
    
}

extension BuddySelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                  image: UIImage(systemName: "trash")) { _ in
                self.delegate?.buddyDidDeleted(indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [delete])
        })
    }
}

protocol BuddyViewDelegate: AnyObject {
    func buddyDidDeleted(_: Int)
    func buddyAddDidTouched()
}
