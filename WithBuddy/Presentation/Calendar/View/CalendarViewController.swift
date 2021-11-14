//
//  CalendarViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine

class CalendarViewController: UIViewController {

    private let detailView = CalendarDetailView() // 지워야 할 것
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var headerView = HeaderView()
    private lazy var calendarView = UIView()
    private lazy var wbCalendar = WBCalendarView()
    
    private let calendarViewModel = CalendarViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.wbCalendar.reload()
        self.calendarViewModel.viewDidAppear()
    }
    
    private func configure() {
        self.wbCalendar.delegate = self
        self.detailView.delegate = self
        self.configureScrollView()
        self.configureContentView()
        self.configureHeaderView()
        self.configureCalendarView()
        self.configurCalendar()
        self.bind()
    }
    
    private func bind() {
        self.calendarViewModel.todaySubject
            .receive(on: DispatchQueue.main)
            .sink{ month in
                self.wbCalendar.reloadMonthLabel(month: month)
            }.store(in: &self.cancellables)
        
        self.calendarViewModel.didDaysReloadSignal
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.wbCalendar.collectionView.reloadData()
            }.store(in: &self.cancellables)
        
        self.wbCalendar.monthButtonSignal
            .receive(on: DispatchQueue.main)
            .sink{ number in
                self.calendarViewModel.didMonthButtonTouched(number: number)
            }.store(in: &self.cancellables)
    }
    
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureHeaderView() {
        self.contentView.addSubview(headerView)
        self.headerView.backgroundColor = .systemBackground
        self.headerView.layer.cornerRadius = 10
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.headerView.heightAnchor.constraint(equalToConstant: 80),
            self.headerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.headerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureCalendarView() {
        self.contentView.addSubview(calendarView)
        self.calendarView.backgroundColor = .systemBackground
        self.calendarView.layer.cornerRadius = 10
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 10),
            self.calendarView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.calendarView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.calendarView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.calendarView.heightAnchor.constraint(equalToConstant: 530)
        ])
    }
    
    private func configurCalendar() {
        self.calendarView.addSubview(wbCalendar)
        self.wbCalendar.collectionView.dataSource = self
        self.wbCalendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.wbCalendar.leadingAnchor.constraint(equalTo: self.calendarView.leadingAnchor, constant: 15),
            self.wbCalendar.trailingAnchor.constraint(equalTo: self.calendarView.trailingAnchor, constant: -15),
            self.wbCalendar.topAnchor.constraint(equalTo: self.calendarView.topAnchor, constant: 15),
            self.wbCalendar.bottomAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: -15)
        ])
    }
    
}

extension CalendarViewController: CalendarCellSelectable {
    
    func presentCellDetail(selectedDate: Date) {
        self.presentDetailModal()
        self.configureDetailLabel(selectedDate: selectedDate)
    }
    
    func presentDetailModal() {
        let calendarDetailNavigationController = UINavigationController(rootViewController: CalendarDetailViewController())
        calendarDetailNavigationController.modalPresentationStyle = .pageSheet
        if let sheet = calendarDetailNavigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.tabBarController?.present(calendarDetailNavigationController, animated: true, completion: nil)
        calendarDetailNavigationController.view.addSubview(detailView)
        self.detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailView.leadingAnchor.constraint(equalTo: calendarDetailNavigationController.view.leadingAnchor),
            self.detailView.trailingAnchor.constraint(equalTo: calendarDetailNavigationController.view.trailingAnchor),
            self.detailView.topAnchor.constraint(equalTo: calendarDetailNavigationController.view.topAnchor),
            self.detailView.bottomAnchor.constraint(equalTo: calendarDetailNavigationController.view.bottomAnchor),
            self.detailView.widthAnchor.constraint(equalTo: calendarDetailNavigationController.view.widthAnchor),
            self.detailView.heightAnchor.constraint(equalTo: calendarDetailNavigationController.view.heightAnchor)
        ])
    }
    
    func configureDetailLabel(selectedDate: Date) {
        self.detailView.saveSelecetedDate(selectedDate: selectedDate)
    }
    
}

extension CalendarViewController: gatheringListDelegate {
    
    func gatheringListTouched() {
        self.tabBarController?.dismiss(animated: true, completion: {
            self.navigationController?.pushViewController(GatheringDetailViewController(), animated: true)
        })
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.calendarViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBCalendarViewCell.identifier, for: indexPath) as? WBCalendarViewCell else { return UICollectionViewCell() }
        cell.update(day: self.calendarViewModel.totalDays(index: indexPath.item))
        return cell
    }
    
}
