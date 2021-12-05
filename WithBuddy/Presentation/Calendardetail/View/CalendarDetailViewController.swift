//
//  CalendarDetailViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/07.
//

import UIKit
import Combine

final class CalendarDetailViewController: UIViewController {
    
    private let detailViewMargin = 15.0
    private var date: Date
    private lazy var detailLabel = PurpleTitleLabel()
    private lazy var detailTableView = UITableView()
    private let calendarDetailViewModel = CalendarDetailViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    weak var delegate: GatheringListDelegate?
    
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.date = Date()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPurple
        self.bind()
        self.configure()
        self.calendarDetailViewModel.viewDidLoad(with: date)
    }
    
    private func bind() {
        self.calendarDetailViewModel.$dayLabel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] label in
                self?.detailLabel.text = label + " 모임"
            }.store(in: &self.cancellables)
        
        self.calendarDetailViewModel.$gatheringList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailTableView.reloadData()
            }.store(in: &self.cancellables)
        
        self.calendarDetailViewModel.deleteSuccessSingal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gathering in
                self?.delegate?.deleteGathering(id: gathering.id)
            }.store(in: &self.cancellables)
    }
    
    private func configure() {
        self.configureDetailLabel()
        self.configureTableView()
    }
    
    private func configureDetailLabel() {
        
        self.view.addSubview(self.detailLabel)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.detailViewMargin),
            self.detailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.detailViewMargin)
        ])
    }
    
    private func configureTableView() {
        self.view.addSubview(detailTableView)
        self.detailTableView.backgroundColor = .backgroundPurple
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.detailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailTableView.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: .plusInset),
            self.detailTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.detailViewMargin),
            self.detailTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.detailViewMargin),
            self.detailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: .minusInset)
        ])
    }
    
}

extension CalendarDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarDetailViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
                        as? ListTableViewCell else { return UITableViewCell() }
        let gathering = self.calendarDetailViewModel[indexPath.item]
        cell.update(date: gathering.date, buddyImageList: gathering.buddyList.map{ $0.face }, typeList: gathering.purpose)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            self.delegate?.didGatheringListTouched(self.calendarDetailViewModel[indexPath.item])
        })
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            self.calendarDetailViewModel.didDeleteButtonTouched(index: indexPath.row)
            completion(true)
        }
        deleteAction.backgroundColor = .graphRed
        deleteAction.image = .deleteImage

        let editAction = UIContextualAction(style: .normal, title: "편집") { _, _, completion in
            self.dismiss(animated: true) {
                self.delegate?.editGathering(self.calendarDetailViewModel[indexPath.row])
            }
            completion(true)
        }
        editAction.backgroundColor = .graphPurple2
        editAction.image = .editImage

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.tableViewHeight
    }

}

protocol GatheringListDelegate: AnyObject {
    
    func didGatheringListTouched(_: Gathering)
    func editGathering(_: Gathering)
    func deleteGathering(id: UUID)
    
}
