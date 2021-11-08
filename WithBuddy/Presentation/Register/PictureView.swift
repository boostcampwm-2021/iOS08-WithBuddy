//
//  PictureView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class PictureView: UIView {
    
    private lazy var pictureTitleLabel = UILabel()
    private lazy var pictureAddButton = UIButton()
    private lazy var pictureCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var pictureDataSource = UICollectionViewDiffableDataSource<Int, URL>(collectionView: self.pictureCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: URL) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.identifer, for: indexPath) as? PictureCollectionViewCell else { preconditionFailure() }
            cell.configure(url: itemIdentifier)
            return cell
        }
    
    var delegate: PictureViewDelegate?
    
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
        self.configureTitleLabel()
        self.configureButton()
        self.configureCollectionView()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.pictureTitleLabel)
        self.pictureTitleLabel.text = "사진"
        self.pictureTitleLabel.textColor = UIColor(named: "LabelPurple")
        self.pictureTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        self.pictureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pictureTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.pictureTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
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
            self.pictureAddButton.centerYAnchor.constraint(equalTo: self.pictureTitleLabel.centerYAnchor),
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
            self.pictureCollectionView.topAnchor.constraint(equalTo: self.pictureTitleLabel.bottomAnchor, constant: 20),
            self.pictureCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.pictureCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.pictureCollectionView.heightAnchor.constraint(equalTo: self.pictureCollectionView.widthAnchor),
            self.pictureCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.pictureCollectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.identifer)
        let pictureFlowLayout = UICollectionViewFlowLayout()
        pictureFlowLayout.scrollDirection = .horizontal
        pictureFlowLayout.itemSize = CGSize(width: 300, height: 300)
        self.pictureCollectionView.collectionViewLayout = pictureFlowLayout
    }
    
    @objc private func onPictureButtonTouched(_ sender: UIButton) {
        self.delegate?.pictureButtonDidTouched()
    }
}

extension PictureView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                       image: UIImage(systemName: "trash")) { action in
                self.delegate?.pictureDidDeleted(indexPath.item)
                }
            return UIMenu(title: "이 사진을", children: [delete])
        })
    }
}

protocol PictureViewDelegate {
    func pictureButtonDidTouched()
    func pictureDidDeleted(_: Int)
}


