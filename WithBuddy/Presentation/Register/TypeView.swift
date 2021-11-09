//
//  TypeView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class TypeView: UIView {
    
    private lazy var typeTitleLabel = UILabel()
    private lazy var typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var delegate: TypeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func changeSelectedType(_ typeSelectedList: [Bool]) {
        for (idx, selected) in typeSelectedList.enumerated() {
            guard let cell = self.typeCollectionView.cellForItem(at: IndexPath(item: idx, section: 0)) else {
                return
            }
            if selected {
                cell.alpha = 1.0
            } else {
                cell.alpha = 0.6
            }
        }
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
        self.typeCollectionView.dataSource = self
        self.typeCollectionView.delegate = self
        self.typeCollectionView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.collectionViewDidTouched(_:)))
        self.typeCollectionView.addGestureRecognizer(tap)
        
        self.typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: TypeCollectionViewCell.identifer)

        let typeFlowLayout = UICollectionViewFlowLayout()
        typeFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.typeCollectionView.collectionViewLayout = typeFlowLayout
        
        self.typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.typeCollectionView.topAnchor.constraint(equalTo: self.typeTitleLabel.bottomAnchor, constant: 20),
            self.typeCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.typeCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.typeCollectionView.heightAnchor.constraint(equalToConstant: 200),
            self.typeCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func collectionViewDidTouched(_ sender: UITapGestureRecognizer) {
       if let indexPath = self.typeCollectionView.indexPathForItem(at: sender.location(in: self.typeCollectionView)) {
           self.delegate?.typeDidSelected(indexPath.item)
       }
    }
}

extension TypeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.identifer, for: indexPath) as? TypeCollectionViewCell else { preconditionFailure() }
        cell.configure(image: UIImage(named: "\(PlaceType.allCases[indexPath.item])"), text: "\(PlaceType.allCases[indexPath.item])")
        return cell
    }
}

protocol TypeViewDelegate {
    func typeDidSelected(_: Int)
}
