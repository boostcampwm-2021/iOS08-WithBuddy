//
//  BuddyView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class BuddyView: UIView {
    
    private lazy var buddyTitleLabel = UILabel()
    private lazy var buddyAddButton = UIButton()
    private lazy var buddyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionVIiewCell.identifer, for: indexPath) as? ImageTextCollectionVIiewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: "FacePurple1"), text: itemIdentifier.name)
        return cell
    }
    
    var delegate: BuddyViewDelegate?
    
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
            snapshot.appendItems([Buddy(id: UUID(), name: "친구없음", face: "")])
        } else {
            snapshot.appendSections([0])
            snapshot.appendItems(buddyList)
        }
        self.buddyDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureButton()
        self.configureCollectionView()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.buddyTitleLabel)
        self.buddyTitleLabel.text = "만난 버디"
        self.buddyTitleLabel.textColor = UIColor(named: "LabelPurple")
        self.buddyTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        self.buddyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.buddyTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
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
            self.buddyAddButton.topAnchor.constraint(equalTo: self.buddyTitleLabel.bottomAnchor, constant: 20),
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
        
        self.buddyCollectionView.register(ImageTextCollectionVIiewCell.self, forCellWithReuseIdentifier: ImageTextCollectionVIiewCell.identifer)
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(60), heightDimension: .absolute(90)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
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
        self.delegate?.buddyDidSelected(Buddy(id: UUID(), name: UUID().uuidString, face: ""))
    }
}

extension BuddyView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                  image: UIImage(systemName: "trash")) { action in
                self.delegate?.buddyDidDeleted(indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [delete])
        })
    }
}

protocol BuddyViewDelegate {
    func buddyDidDeleted(_: Int)
    func buddyDidSelected(_: Buddy)
}
