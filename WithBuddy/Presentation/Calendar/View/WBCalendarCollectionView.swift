//
//  WBCalendarCollectionView.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/14.
//

import UIKit

final class WBCalendarCollectionView: UICollectionView {

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        self.register(WBCalendarViewCell.self, forCellWithReuseIdentifier: WBCalendarViewCell.identifier)
        self.configureLayout()
    }
    
    private func configureLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/7.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0/6.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        self.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
}
