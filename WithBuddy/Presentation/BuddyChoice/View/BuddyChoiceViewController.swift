//
//  BuddyChoiceViewController.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import UIKit
import Combine

final class BuddyChoiceViewController: UIViewController {
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.didCompleteButtonTouched))
    }
    
    func configureBuddyList(by buddyList: [Buddy]) {
        self.buddyChoiceViewModel.didBuddyListLoaded(by: buddyList)
    }
    
    private func bind() {
        self.buddyChoiceViewModel.$storedBuddyList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buddyList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Buddy>()
                snapshot.appendSections([Int.zero])
                snapshot.appendItems(buddyList)
                self?.buddyDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyChoiceViewModel.doneSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] checkedBuddyList in
                self?.delegate?.didBuddySelectingCompleted(checkedBuddyList)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellables)
        
        self.buddyChoiceViewModel.failSignal
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
    }
    
    private func configureSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.searchTextField.delegate = self
        self.searchView.layer.cornerRadius = .whiteViewCornerRadius
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .plusInset),
            self.searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: .minusInset),
            self.searchView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureButton() {
        self.view.addSubview(self.addButton)
        let config = UIImage.SymbolConfiguration(
            pointSize: 60, weight: .medium, scale: .default)
        let image = UIImage(named: "PlusBuddy", in: .main, with: config)
        self.addButton.setImage(image, for: .normal)
        self.addButton.addTarget(self, action: #selector(self.didNewBuddyButtonTouched), for: .touchUpInside)
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: .innerPartInset),
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
        self.buddyCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didCollectionViewTouched)))
        
        let buddyFlowLayout = UICollectionViewFlowLayout()
        buddyFlowLayout.scrollDirection = .vertical
        buddyFlowLayout.itemSize = CGSize(width: 60, height: 90)
        self.buddyCollectionView.collectionViewLayout = buddyFlowLayout
        
        self.buddyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buddyCollectionView.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: .innerPartInset),
            self.buddyCollectionView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.buddyCollectionView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.buddyCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: .minusInset)
        ])
    }
    
    private func alertError(_ error: BuddyChoiceError) {
        var titleMessage = String()
        switch error {
        case .oneMoreGathering: titleMessage = "삭제 실패"
        case .noBuddy: titleMessage = "등록 실패"
        }
        let alert = UIAlertController(title: titleMessage, message: error.errorDescription, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didNewBuddyButtonTouched(_ sender: UIButton) {
        let buddyCustomViewController = BuddyCustomViewController()
        buddyCustomViewController.delegate = self
        self.navigationController?.pushViewController(buddyCustomViewController, animated: true)
    }
    
    @objc private func didCompleteButtonTouched() {
        self.buddyChoiceViewModel.didBuddySelectingCompleted()
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
    
    @objc func didCollectionViewTouched(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageTextCollectionViewCell else { return }
        cell.animateButtonTap()
        self.buddyChoiceViewModel.didBuddyChecked(in: indexPath.item)
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let edit = UIAction(title: NSLocalizedString("편집", comment: String()),
                                image: UIImage(systemName: "pencil.circle")) { _ in
                let buddyCustomViewController = BuddyCustomViewController()
                buddyCustomViewController.delegate = self
                buddyCustomViewController.configure(by: self.buddyChoiceViewModel[indexPath.item])
                self.navigationController?.pushViewController(buddyCustomViewController, animated: true)
            }
            let delete = UIAction(title: NSLocalizedString("삭제", comment: String()),
                                  image: UIImage(systemName: "trash")) { _ in
                self.buddyChoiceViewModel.didBuddyDeleted(in: indexPath.item)
            }
            return UIMenu(title: "이 버디를", children: [edit, delete])
        })
    }
    
}

extension BuddyChoiceViewController: BuddyCustomDelegate {
    
    func didBuddyEditCompleted(_ buddy: Buddy) {
        self.buddyChoiceViewModel.didBuddyEdited(buddy)
    }
    
    func didBuddyAddCompleted(_ buddy: Buddy) {
        self.buddyChoiceViewModel.didBuddyAdded(buddy)
    }
    
}

extension BuddyChoiceViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        self.view.endEditing(true)
        return true
   }
    
}

protocol BuddyChoiceDelegate: AnyObject {
    
    func didBuddySelectingCompleted(_: [Buddy])
    
}
