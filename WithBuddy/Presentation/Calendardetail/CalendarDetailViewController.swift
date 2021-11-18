//
//  CalendarDetailViewController.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/07.
//

import UIKit
import Combine

class CalendarDetailViewController: UIViewController {
    
    private lazy var detailLabel = UILabel()
    private lazy var detailTableView = UITableView()
    private var calendarDetailViewModel: CalendarDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    weak var delegate: GatheringListDelegate?
    
    init(calendarDetailViewModel: CalendarDetailViewModel) {
        self.calendarDetailViewModel = calendarDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.calendarDetailViewModel = CalendarDetailViewModel(selectedDate: Date())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundPurple")
        self.bind()
        self.configure()
    }
    
    private func bind() {
        self.calendarDetailViewModel.$dayLabel
        .receive(on: DispatchQueue.main)
        .sink{ label in
            self.detailLabel.text = label + " 모임"
        }.store(in: &self.cancellables)
        
        self.calendarDetailViewModel.$gatheringList
        .receive(on: DispatchQueue.main)
        .sink{ _ in
            self.detailTableView.reloadData()
        }.store(in: &self.cancellables)
    }
    
    private func configure() {
        self.configureDetailLabel()
        self.configureDetailCollectionView()
    }
    
    private func configureDetailLabel() {
        self.view.addSubview(self.detailLabel)
        self.detailLabel.font = .boldSystemFont(ofSize: 20)
        self.detailLabel.textColor = UIColor(named: "LabelPurple")
        
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15),
            self.detailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        ])
    }
    
    private func configureDetailCollectionView() {
        self.view.addSubview(detailTableView)
        self.detailTableView.backgroundColor = UIColor(named: "BackgroundPurple")
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.detailTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailTableView.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 20),
            self.detailTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.detailTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.detailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        ])
    }
    
}

extension CalendarDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.calendarDetailViewModel.count
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
            self.delegate?.gatheringListTouched(self.calendarDetailViewModel[indexPath.item])
        })
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            self.calendarDetailViewModel.deleteGathering(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(named: "GraphRed")
        deleteAction.image = UIImage(named: "FaceRed1")

        let editAction = UIContextualAction(style: .normal, title: "편집") { _, _, completion in
            completion(true)
        }
        editAction.backgroundColor = UIColor(named: "GraphPurple2")
        editAction.image = UIImage(named: "FacePurple1")

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.tableViewHeight
    }

}

protocol GatheringListDelegate: AnyObject {
    func gatheringListTouched(_: Gathering)
}
