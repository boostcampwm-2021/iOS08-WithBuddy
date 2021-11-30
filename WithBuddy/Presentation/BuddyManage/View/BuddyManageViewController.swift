//
//  BuddyManageViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/16.
//

import UIKit
import Combine

final class BuddyManageViewController: UIViewController {

    private let searchView = SearchView()
    private let addButton = UIButton()
    private let buddyCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var buddyManageViewModel = BuddyManageViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var buddyDataSource = UICollectionViewDiffableDataSource<Int, Buddy>(collectionView: self.buddyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Buddy) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.identifier, for: indexPath) as? ImageTextCollectionViewCell else { preconditionFailure() }
        cell.update(image: UIImage(named: itemIdentifier.face), text: itemIdentifier.name)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "버디 관리"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = nil
    }
    
    private func bind() {
        self.buddyManageViewModel.$storedBuddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                snapshot.appendSections([0])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyManageViewModel.failSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.alertError(result)
            }
            .store(in: &self.cancellables)
    }
    
    private func configure() {
        self.view.backgroundColor = .backgroundPurple
        self.configureSearchView()
        self.configureButton()
        self.configureBuddyCollectionView()
        self.buddyManageViewModel.buddyListDidLoaded()
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
        let image = UIImage(named: "PlusBuddy", in: .main, with: config)
        self.addButton.setImage(image, for: .normal)
        self.addButton.addTarget(self, action: #selector(self.newBuddyButtonTouched(_:)), for: .touchUpInside)
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 10),
            self.addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.addButton.heightAnchor.constraint(equalToConstant: .buddyAndPurposeWidth),
            self.addButton.widthAnchor.constraint(equalTo: self.addButton.heightAnchor)
        ])
    }
    
    private func configureBuddyCollectionView() {
        self.view.addSubview(self.buddyCollectionView)
        self.buddyCollectionView.backgroundColor = .clear
        self.buddyCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.identifier)
        self.buddyCollectionView.delegate = self
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self
        self.buddyCollectionView.addGestureRecognizer(panGesture)
        self.buddyCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        
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
    
    @objc private func newBuddyButtonTouched(_ sender: UIButton) {
        let buddyCustomViewController = BuddyCustomViewController()
        buddyCustomViewController.delegate = self
        buddyCustomViewController.title = "버디 생성"
        self.navigationController?.pushViewController(buddyCustomViewController, animated: true)
    }
    
    private func searchBuddy(by text: String) {
        let buddyList = self.buddyManageViewModel.storedBuddyList
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
    
    private func alertError(_ error: BuddyChoiceError) {
        let alert = UIAlertController(title: "삭제 실패", message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension BuddyManageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.searchBuddy(by: text)
    }

}

extension BuddyManageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let edit = UIAction(title: NSLocalizedString("편집", comment: ""),
                                image: UIImage(systemName: "pencil.circle")) { _ in
                let buddyCustomViewController = BuddyCustomViewController()
                buddyCustomViewController.delegate = self
                buddyCustomViewController.title = "버디 편집"
                buddyCustomViewController.configure(by: self.buddyManageViewModel[indexPath.item])
                self.navigationController?.pushViewController(buddyCustomViewController, animated: true)
            }
            let delete = UIAction(title: NSLocalizedString("삭제", comment: ""),
                                  image: UIImage(systemName: "trash")) { _ in
                self.buddyManageViewModel.buddyDidDeleted(in: indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [edit, delete])
        })
    }

}

extension BuddyManageViewController: BuddyCustomDelegate {
    
    func buddyEditDidCompleted(_ buddy: Buddy) {
        self.buddyManageViewModel.buddyDidEdited(buddy)
    }
    
    func buddyAddDidCompleted(_ buddy: Buddy) {
        self.buddyManageViewModel.buddyDidAdded(buddy)
    }
    
}

extension BuddyManageViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        self.view.endEditing(true)
        return true
   }
    
}
