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
    private lazy var todayButton = UIButton()
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
        self.configureTodayButton()
        self.configureWeekDays()
        self.configureCollectionView()
        self.configureTapGesture()
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
        self.addSubview(self.prevMonthButton)
        self.addSubview(self.nextMonthButton)
        self.prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.prevMonthButton.addTarget(self, action: #selector(self.minusMonth), for: .touchUpInside)
        self.nextMonthButton.addTarget(self, action: #selector(self.plusMonth), for: .touchUpInside)
        self.prevMonthButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.prevMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.prevMonthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100),
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100)
        ])
    }
    
    private func configureTodayButton() {
        self.addSubview(self.todayButton)
        self.todayButton.setTitle("Today", for: .normal)
        self.todayButton.backgroundColor = UIColor(named: "LabelPurple")
        self.todayButton.layer.cornerRadius = 5
        self.todayButton.tintColor = .white
        self.todayButton.titleLabel?.font = .systemFont(ofSize: 13)
        self.todayButton.addTarget(self, action: #selector(self.thisMonth), for: .touchUpInside)
        self.todayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.todayButton.widthAnchor.constraint(equalToConstant: 10 +  (self.todayButton.titleLabel?.intrinsicContentSize.width ?? 0)),
            self.todayButton.leadingAnchor.constraint(equalTo: self.nextMonthButton.trailingAnchor, constant: 15),
            self.todayButton.centerYAnchor.constraint(equalTo: self.thisMonthLabel.centerYAnchor)
        ])
    }
    
    private func configureWeekDays() {
        self.addSubview(self.weekStackView)
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
        self.addSubview(self.collectionView)
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.weekStackView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.weekStackView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureTapGesture() {
        let swipeLeftToRight = UISwipeGestureRecognizer(target: self, action: #selector(self.minusMonth))
        swipeLeftToRight.direction = UISwipeGestureRecognizer.Direction.right
        self.collectionView.addGestureRecognizer(swipeLeftToRight)
        let swipeRightToLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.plusMonth))
        swipeRightToLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.collectionView.addGestureRecognizer(swipeRightToLeft)
    }
    
    private func makeWeekLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "LabelPurple")
        label.textAlignment = .center
        return label
    }
    
    @objc private func thisMonth(_ sender: UIButton) {
        self.collectionView.fadeAnimation()
        self.monthButtonSignal.send(0)
        self.todayButton.animateButtonTap(scale: 0.9)
    }
    
    @objc private func minusMonth(_ sender: UIButton) {
        self.collectionView.fadeAnimation()
        self.monthButtonSignal.send(-1)
    }
    
    @objc private func plusMonth(_ sender: UIButton) {
        self.collectionView.fadeAnimation()
        self.monthButtonSignal.send(1)
    }
    
}
