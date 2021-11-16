//
//  CalendarViewController.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/01.
//

import UIKit
import Combine

class CalendarViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var headerView = HeaderView()
    private lazy var calendarView = WBCalendarView()
    
    private let calendarViewModel = CalendarViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calendarViewModel.viewDidAppear()
    }
    
    private func configure() {
        self.bind()
        self.configureScrollView()
        self.configureContentView()
        self.configureHeaderView()
        self.configurCalendar()
    }
    
    private func bind() {
        self.calendarViewModel.monthSubject
            .receive(on: DispatchQueue.main)
            .sink{ month in
                self.calendarView.reloadMonthLabel(month: month)
            }.store(in: &self.cancellables)
        
        self.calendarViewModel.didDaysReloadSignal
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.calendarView.collectionView.reloadData()
            }.store(in: &self.cancellables)
        
        self.calendarViewModel.didGatheringReloadSignal
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.calendarView.collectionView.reloadData()
            }.store(in: &self.cancellables)
        
        self.calendarView.monthButtonSignal
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
    
    private func configurCalendar() {
        self.contentView.addSubview(calendarView)
        self.calendarView.backgroundColor = .systemBackground
        self.calendarView.layer.cornerRadius = 10
        self.calendarView.collectionView.delegate = self
        self.calendarView.collectionView.dataSource = self
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.calendarView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.calendarView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 10),
            self.calendarView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.calendarView.heightAnchor.constraint(equalTo: self.calendarView.widthAnchor, multiplier: 1.6)
        ])
    }
    
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.calendarViewModel.maxDayOfMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBCalendarViewCell.identifier, for: indexPath) as? WBCalendarViewCell else { return UICollectionViewCell() }
        let day = self.calendarViewModel.totalDays.indices ~= indexPath.item ? self.calendarViewModel.totalDays[indexPath.item] : 0
        let face = self.calendarViewModel.totalFaces.indices ~= indexPath.item ? self.calendarViewModel.totalFaces[indexPath.item] : ""
        cell.update(day: day, face: face)
        
        if let index = self.calendarViewModel.isSameMonth, index == indexPath.item {
            cell.highlightCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let calendarDetailViewController = CalendarDetailViewController(
            calendarDetailViewModel: CalendarDetailViewModel(
                selectedDate: self.calendarViewModel.findDate(index: indexPath.item)
            )
        )
        calendarDetailViewController.delegate = self
        
        if let presentationController = calendarDetailViewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
        }
        
        self.present(calendarDetailViewController, animated: true)
    }
    
}

extension CalendarViewController: GatheringListDelegate {
    
    func gatheringListTouched(_ gathering: Gathering) {
            let gatheringDetailViewController = GatheringDetailViewController()
            gatheringDetailViewController.configure(by: gathering)
            self.navigationController?.pushViewController(gatheringDetailViewController, animated: true)
    }
    
}
