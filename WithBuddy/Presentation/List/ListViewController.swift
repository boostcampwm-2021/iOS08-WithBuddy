//
//  ListViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    
    private let searchView = SearchView()
    private let listTableView = UITableView()
    
    private lazy var listDataSource = UITableViewDiffableDataSource<Int, Gathering>(tableView: self.listTableView) { (tableView: UITableView, indexPath: IndexPath, itemIdentifier: Gathering) -> UITableViewCell? in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.update(date: itemIdentifier.date, buddyImageList: itemIdentifier.buddyList.map{ $0.face }, typeList: itemIdentifier.purpose)
        return cell
    }
    
    private let listViewModel = ListViewModel(
        buddyUseCase: BuddyUseCase(
            coreDataManager: CoreDataManager.shared
        ),
        gatheringUseCase: GatheringUseCase(
            coreDataManager: CoreDataManager.shared
        )
    )
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listViewModel.fetch()
        self.searchView.reset()
    }
    
    private func configure() {
        self.configureSearchView()
        self.configureCollectionView()
    }
    
    private func bind() {
        self.listViewModel.$gatheringList
            .sink { [weak self] getheringList in
                self?.reloadGathering(list: getheringList)
            }
            .store(in: &self.cancellables)
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
    
    private func configureCollectionView() {
        self.view.addSubview(self.listTableView)
        self.listTableView.delegate = self
        self.listTableView.backgroundColor = .clear
        self.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.listTableView.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 20),
            self.listTableView.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor),
            self.listTableView.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor),
            self.listTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func reloadGathering(list: [Gathering]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Gathering>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        self.listDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func reloadGathering(filter: String) {
        let gatheringList = self.listViewModel.gatheringList
        let filtered = gatheringList.filter{ $0.buddyList.contains{ $0.name.contains(filter) } }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Gathering>()
        snapshot.appendSections([0])
        if filter.isEmpty {
            snapshot.appendItems(gatheringList)
        } else {
            snapshot.appendItems(filtered)
            self.listViewModel.searched(list: filtered)
        }
        self.listDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.reloadGathering(filter: text)
    }
    
}

extension ListViewController: UITableViewDelegate {
    
<<<<<<< HEAD
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-40, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell else { return }
        cell.animateButtonTap(scale: 0.9)
        
=======
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
>>>>>>> d6b3e74 ((#89) feat: 모임 목록, 달력 상세 화면 CollectionView를 TableView로 변경)
        let viewController = GatheringDetailViewController()
        viewController.configure(by: self.listViewModel[indexPath.item])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.tableViewHeight
    }
    
}
