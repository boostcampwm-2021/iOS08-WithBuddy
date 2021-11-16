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
    private lazy var detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calendarDetailViewModel: CalendarDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
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
            self.detailLabel.text = label + "모임"
        }.store(in: &self.cancellables)
        
        self.calendarDetailViewModel.$gatheringList
        .receive(on: DispatchQueue.main)
        .sink{ gatheringList in
            print(gatheringList.count)
        }.store(in: &self.cancellables)
    }
    
    private func configure() {
        self.configureDetailLabel()
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
    
}
