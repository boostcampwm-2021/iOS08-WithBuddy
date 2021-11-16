//
//  WBCalendar.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit
import Combine

class WBCalendarView: UIView {
    
    private let calendarManager = CalendarUseCase()
    private lazy var thisMonthLabel = UILabel()
    private lazy var prevMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private(set) lazy var collectionView = WBCalendarCollectionView()
    
    private(set) var monthButtonSignal = PassthroughSubject<Int, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
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
    
    private func configureThisMonth() {
        self.addSubview(thisMonthLabel)
        self.thisMonthLabel.textColor = UIColor(named: "LabelPurple")
        self.thisMonthLabel.font = .boldSystemFont(ofSize: 17)
        self.thisMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thisMonthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
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
            self.prevMonthButton.trailingAnchor.constraint(equalTo: self.thisMonthLabel.leadingAnchor, constant: -15),
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.nextMonthButton.leadingAnchor.constraint(equalTo: self.thisMonthLabel.trailingAnchor, constant: 15)
        ])
    }
    
    private func configureWeekDays() {
        self.addSubview(weekStackView)
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.thisMonthLabel.bottomAnchor, constant: 30),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
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
    
    private func configureCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.weekStackView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.weekStackView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func makeWeekLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "LabelPurple")
        label.textAlignment = .center
        return label
    }
    
    @objc private func minusMonth(_ sender: UIButton) {
        self.monthButtonSignal.send(-1)
    }
    
    @objc private func plusMonth(_ sender: UIButton) {
        self.monthButtonSignal.send(1)
    }
    
}