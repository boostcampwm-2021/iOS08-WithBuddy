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
    
    private lazy var typeDataSource = UICollectionViewDiffableDataSource<Int, Purpose>(collectionView: self.typeCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Purpose) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifer, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: "\(itemIdentifier.type)"), text: "\(itemIdentifier.type)", check: itemIdentifier.check)
        return cell
    }
    
    var delegate: TypeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func changeSelectedType(_ purposeList: [Purpose]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Purpose>()
        snapshot.appendSections([0])
        snapshot.appendItems(purposeList)
        self.typeDataSource.apply(snapshot, animatingDifferences: true)
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
        self.typeCollectionView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.collectionViewDidTouched(_:)))
        self.typeCollectionView.addGestureRecognizer(tap)
        self.typeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifer)

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

protocol TypeViewDelegate {
    func typeDidSelected(_: Int)
}
