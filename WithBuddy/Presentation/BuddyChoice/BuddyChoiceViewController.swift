//
//  BuddyChoiceViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import UIKit
import Combine

class BuddyChoiceViewController: UIViewController {
    
    private let searchView = SearchView()
    private let addButton = UIButton()
    private let buddyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var buddyChoiceViewModel = BuddyChoiceViewModel()
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: BuddyChoiceDelegate?
    
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.face), text: itemIdentifier.name, check: itemIdentifier.check)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.completeButtonTouched))
    }
    
    func configureBuddyList(by buddyList: [Buddy]) {
        self.buddyChoiceViewModel.buddyListDidLoaded(by: buddyList)
    }
    
    private func bind() {
        self.buddyChoiceViewModel.$storedBuddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                snapshot.appendSections([0])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyChoiceViewModel.doneSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] checkedBuddyList in
                self?.delegate?.buddySelectingDidCompleted(checkedBuddyList)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyChoiceViewModel.failSignal
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                self?.alertError(result)
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.configureSearchView()
        self.configureButton()
        self.configureBuddyCollectionView()
    }
    
    private func configureSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.searchTextField.delegate = self
        self.searchView.layer.cornerRadius = 10
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureButton() {
        self.view.addSubview(self.addButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 60, weight: .medium, scale: .default)
        let image = UIImage(systemName: "person.badge.plus", withConfiguration: config)
        self.addButton.setImage(image, for: .normal)
        self.addButton.addTarget(self, action: #selector(self.newBuddyButtonTouched(_:)), for: .touchUpInside)
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 10),
            self.addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureBuddyCollectionView() {
        self.view.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        self.buddyCollectionView.delegate = self
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .vertical
        buddyFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 10),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.buddyCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func alertError(_ error: BuddyChoiceError) {
        let alert = UIAlertController(title: "등록 실패", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func newBuddyButtonTouched(_ sender: UIButton) {
        let buddyUsecase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
        self.buddyChoiceViewModel.buddyDidAdded(buddyUsecase.makeRandomBuddy())
        self.navigationController?.pushViewController(BuddyCustomViewController(), animated: true)
    }
    
    @objc private func completeButtonTouched() {
        self.buddyChoiceViewModel.buddySelectingDidCompleted()
    }
    
    private func searchBuddy(by text: String) {
        let buddyList = self.buddyChoiceViewModel.storedBuddyList
        let filtered = buddyList.filter{ $0.name.contains(text) }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
        snapshot.appendSections([0])
        if text.isEmpty {
            snapshot.appendItems(buddyList)
        } else {
            snapshot.appendItems(filtered)
        }
        self.buddyDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension BuddyChoiceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.searchBuddy(by: text)
    }
    
}

extension BuddyChoiceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.buddyChoiceViewModel.buddyDidChecked(in: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let edit = UIAction(title: NSLocalizedString("편집", comment: ""),
                                image: UIImage(systemName: "pencil.circle")) { _ in
                self.navigationController?.pushViewController(BuddyCustomViewController(), animated: true)
            }
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                  image: UIImage(systemName: "trash")) { _ in
                self.buddyChoiceViewModel.buddyDidADeleted(in: indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [edit, delete])
        })
    }
    
}

protocol BuddyChoiceDelegate: AnyObject {
    func buddySelectingDidCompleted(_: [Buddy])
}
