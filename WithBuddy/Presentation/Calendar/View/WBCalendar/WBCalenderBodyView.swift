//
//  WBCalanderBodyView.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class WBCalenderBodyView: UIView {
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCalendar()
    }
    
    private func configureCalendar() {
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        collectionView.backgroundColor = .yellow
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
