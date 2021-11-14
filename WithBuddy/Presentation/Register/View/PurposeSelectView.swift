//
//  PurposeSelectView.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/06.
//

import UIKit
import Combine

final class PurposeSelectView: UIView {
    
    private lazy var purposeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var purposeDataSource = UICollectionViewDiffableDataSource<Int, Purpose>(collectionView: self.purposeCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Purpose) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: "\(itemIdentifier.type)"), text: "\(itemIdentifier.type)", check: itemIdentifier.check)
        return cell
    }
    
    weak var delegate: PurposeViewDelegate?
    
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
        self.purposeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure() {
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        self.addSubview(self.purposeCollectionView)
        self.purposeCollectionView.backgroundColor = .clear
        self.purposeCollectionView.showsHorizontalScrollIndicator = false
        self.purposeCollectionView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.collectionViewDidTouched(_:)))
        self.purposeCollectionView.addGestureRecognizer(tap)
        self.purposeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)

        let purposeFlowLayout = UICollectionViewFlowLayout()
        purposeFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.purposeCollectionView.collectionViewLayout = purposeFlowLayout
        
        self.purposeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purposeCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.purposeCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.purposeCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.purposeCollectionView.heightAnchor.constraint(equalToConstant: 200),
            self.purposeCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func collectionViewDidTouched(_ sender: UITapGestureRecognizer) {
       if let indexPath = self.purposeCollectionView.indexPathForItem(at: sender.location(in: self.purposeCollectionView)) {
           self.delegate?.purposeDidSelected(indexPath.item)
       }
    }
    
}

protocol PurposeViewDelegate: AnyObject {
    func purposeDidSelected(_: Int)
}
