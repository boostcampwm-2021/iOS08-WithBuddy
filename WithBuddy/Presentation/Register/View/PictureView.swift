//
//  PictureView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class PictureView: UIView {
    
    private lazy var pictureAddButton = UIButton()
    private lazy var pictureCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var pictureDataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: self.pictureCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: URL) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifier, for: indexPath) as? PictureCollectionViewCell else { preconditionFailure() }
        cell.configure(url: itemIdentifier)
        return cell
    }
    
    weak var delegate: PictureViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func pictureListReload(_ pictures: [URL]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, URL>()
        if pictures.isEmpty {
            guard let filePath = Bundle.main.path(forResource: "defaultImage", ofType: "png") else {
                return
            }
            let fileUrl = URL(fileURLWithPath: filePath)
            snapshot.appendSections([0])
            snapshot.appendItems([fileUrl])
        } else {
            snapshot.appendSections([0])
            snapshot.appendItems(pictures)
        }
        self.pictureDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure() {
        self.configureButton()
        self.configureCollectionView()
    }
    
    private func configureButton() {
        self.addSubview(self.pictureAddButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .medium, scale: .default)
        let image = UIImage(systemName: "plus.square", withConfiguration: config)
        self.pictureAddButton.setImage(image, for: .normal)
        self.pictureAddButton.addTarget(self, action: #selector(self.onPictureButtonTouched(_:)), for: .touchUpInside)
        
        self.pictureAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureAddButton.centerYAnchor.constraint(equalTo: self.topAnchor),
            self.pictureAddButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.pictureAddButton.widthAnchor.constraint(equalToConstant: 30),
            self.pictureAddButton.heightAnchor.constraint(equalTo: self.pictureAddButton.widthAnchor)
        ])
        
    }
    
    private func configureCollectionView() {
        self.addSubview(self.pictureCollectionView)
        self.pictureCollectionView.backgroundColor = .clear
        self.pictureCollectionView.showsHorizontalScrollIndicator = false
        self.pictureCollectionView.isUserInteractionEnabled = true
        self.pictureCollectionView.delegate = self
        
        self.pictureCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureCollectionView.topAnchor.constraint(equalTo: self.pictureAddButton.bottomAnchor, constant: 20),
            self.pictureCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.pictureCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.pictureCollectionView.heightAnchor.constraint(equalTo: self.pictureCollectionView.widthAnchor),
            self.pictureCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.pictureCollectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifier)
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        item.contentInsets = .init(top: 0, leading: 5, bottom: 16, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        self.pictureCollectionView.collectionViewLayout = layout
    }
    
    @objc private func onPictureButtonTouched(_ sender: UIButton) {
        self.delegate?.pictureButtonDidTouched()
    }
    
}

extension PictureView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { _ in
                self.delegate?.pictureDidDeleted(indexPath.item)
            }
            return UIMenu(title: "이 사진을", children: [delete])
        })
    }
}

protocol PictureViewDelegate: AnyObject {
    func pictureButtonDidTouched()
    func pictureDidDeleted(_: Int)
}
