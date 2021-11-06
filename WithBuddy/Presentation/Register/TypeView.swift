//
//  TypeView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit

final class TypeView: UIView {
    
    private lazy var typeTitleLabel = UILabel()
    private lazy var typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var typeDataSource = UICollectionViewDiffableDataSource<Int, PlaceType>(collectionView: self.typeCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: PlaceType) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifer, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
            cell.configure(image: UIImage(named: "FaceRed"), text: itemIdentifier.rawValue)
            return cell
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.configureTitleLabel()
        self.configureCollectionView()
    }
    
    private func configureTitleLabel() {
        self.addSubview(self.typeTitleLabel)
        self.typeTitleLabel.text = "모임 목적"
        self.typeTitleLabel.textColor = UIColor(named: "LabelPurple")
        self.typeTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        self.typeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.typeTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.addSubview(self.typeCollectionView)
        self.typeCollectionView.backgroundColor = .clear
        self.typeCollectionView.showsHorizontalScrollIndicator = false
        
        self.typeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifer)

        let typeFlowLayout = UICollectionViewFlowLayout()
        typeFlowLayout.scrollDirection = .horizontal
        typeFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.typeCollectionView.collectionViewLayout = typeFlowLayout
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, PlaceType>()
        snapshot.appendSections([0])
        snapshot.appendItems(PlaceType.allCases)
        self.typeDataSource.apply(snapshot, animatingDifferences: true)
        
        self.typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeCollectionView.topAnchor.constraint(equalTo: self.typeTitleLabel.bottomAnchor, constant: 20),
            self.typeCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.typeCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.typeCollectionView.heightAnchor.constraint(equalToConstant: 200),
            self.typeCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
