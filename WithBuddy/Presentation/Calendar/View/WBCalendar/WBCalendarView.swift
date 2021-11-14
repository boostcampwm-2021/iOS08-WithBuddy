//
//  WBCalendar.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class WBCalendarView: UIView {
    
    private let calendarManager = CalendarManager()
    private lazy var thisMonthLabel = UILabel()
    private lazy var prevMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private(set) lazy var collectionView = WBCalendarCollectionView()
    private let wbcalendarViewModel = CalendarViewModel()
    
    private var firstDayOfThisMonth = Date()
    weak var delegate: CalendarCellSelectable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.configureCalendar()
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCalendar()
    }
    
    private func configure() {
        self.configureThisMonth()
        self.configureButton()
        self.configureWeekDays()
        self.configureCollectionView()
    }
    
    func reloadMonthLabel(month: String) {
        self.thisMonthLabel.text = month
    }
    
    func reload() {
//        self.reloadThisMonth()
//        self.reloadDays()
//        self.reloadFace()
    }
    
    private func configureCalendar() {
        self.reloadThisMonth()
        self.configureThisMonth()
        self.configureButton()
        self.configureWeekDays()
        self.reloadDays()
        self.configureCollectionView()
        self.reloadFace()
    }

    private func reloadThisMonth() {
//        let numOfDays = self.calendarManager.numOfDaysInMonth(baseDate: firstDayOfThisMonth)
//        self.firstDayOfThisMonth = calendarManager.firstDateOfMonth(baseDate: firstDayOfThisMonth)
//        self.wbcalendarViewModel.thisMonthGatheringList(thisMonth: firstDayOfThisMonth, numOfDays: numOfDays)
//        self.thisMonthLabel.text = calendarManager.year(baseDate: firstDayOfThisMonth) + "년 "
//                                + calendarManager.month(baseDate: firstDayOfThisMonth) + "월"
    }
    
    private func configureThisMonth() {
        self.addSubview(thisMonthLabel)
        self.thisMonthLabel.textColor = UIColor(named: "LabelPurple")
        self.thisMonthLabel.font = .boldSystemFont(ofSize: 17)
        self.thisMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thisMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.thisMonthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func configureButton() {
        self.addSubview(prevMonthButton)
        self.addSubview(nextMonthButton)
        self.prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.prevMonthButton.addTarget(self, action: #selector(minusMonth), for: .touchUpInside)
        self.nextMonthButton.addTarget(self, action: #selector(plusMonth), for: .touchUpInside)
        self.prevMonthButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.prevMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.prevMonthButton.trailingAnchor.constraint(equalTo: self.thisMonthLabel.leadingAnchor),
            self.prevMonthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.nextMonthButton.leadingAnchor.constraint(equalTo: self.thisMonthLabel.trailingAnchor)
        ])
    }
    
    private func configureWeekDays() {
        self.addSubview(weekStackView)
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.thisMonthLabel.bottomAnchor, constant: 30),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        self.weekStackView.axis = .horizontal
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "일"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "월"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "화"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "수"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "목"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "금"))
        self.weekStackView.addArrangedSubview(self.makeWeekLabel(text: "토"))
        self.weekStackView.distribution = .fillEqually
    }
    
    private func makeWeekLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "LabelPurple")
        label.textAlignment = .center
        return label
    }
    
    @objc private func minusMonth(_ sender: UIButton) {
        let prevMonth = self.calendarManager.minusMonth(baseDate: self.firstDayOfThisMonth)
        self.firstDayOfThisMonth = self.calendarManager.firstDateOfMonth(baseDate: prevMonth)
        self.reload()
    }
    
    @objc private func plusMonth(_ sender: UIButton) {
        let nextMonth = self.calendarManager.plusMonth(baseDate: firstDayOfThisMonth)
        self.firstDayOfThisMonth = self.calendarManager.firstDateOfMonth(baseDate: nextMonth)
        self.reload()
    }
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func reloadDays() {
        self.wbcalendarViewModel.reloadDays(date: self.firstDayOfThisMonth)
        self.collectionView.reloadData()
    }
    
    func reloadFace() {
        self.wbcalendarViewModel.reloadFace(date: self.firstDayOfThisMonth)
        self.collectionView.reloadData()
    }
    
}

extension WBCalendarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wbcalendarViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBCalendarViewCell.identifier, for: indexPath) as? WBCalendarViewCell else { return UICollectionViewCell() }
        let numberOfDay = self.wbcalendarViewModel.totalDays(index: indexPath.item)
        let today = self.calendarManager.pickDay(baseDate: self.firstDayOfThisMonth, numberOfDay: numberOfDay)
        let numOfDay = self.wbcalendarViewModel.totalDays(index: indexPath.item)
        let faceOfDay = self.wbcalendarViewModel.totalFaces(index: indexPath.item)
        if self.wbcalendarViewModel.isFace {
            cell.update(day: numOfDay, face: faceOfDay, today: today)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let numberOfDay = self.wbcalendarViewModel.totalDays(index: indexPath.item)
        let today = self.calendarManager.pickDay(baseDate: self.firstDayOfThisMonth, numberOfDay: numberOfDay)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.animateButtonTap(duration: 0.4, scale: 0.90)
        if self.wbcalendarViewModel.isGathering(in: today) {
            self.delegate?.presentCellDetail(selectedDate: today)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.size.width) / 7
        let height = (self.frame.size.width) / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

protocol CalendarCellSelectable: AnyObject {
    func presentCellDetail(selectedDate: Date)
}
