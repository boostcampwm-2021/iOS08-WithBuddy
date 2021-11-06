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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifer, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
            cell.configure(image: UIImage(named: "Purple1"), text: itemIdentifier.name)
            return cell
        }
    
    private var cancellables: Set<AnyCancellable> = []
    var registerViewModel: RegisterViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    func bind(_ registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
        self.registerViewModel?.$buddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                
                snapshot.appendSections([0])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
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
        
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifer)
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .horizontal
        buddyFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
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
        self.registerViewModel?.didBuddySelected(Buddy(name: UUID().uuidString))
    }
}
