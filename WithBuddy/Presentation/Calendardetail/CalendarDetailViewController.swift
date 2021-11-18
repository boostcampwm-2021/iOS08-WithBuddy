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
            self.detailCollectionView.reloadData()
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
        self.view.addSubview(detailCollectionView)
        self.detailCollectionView.backgroundColor = UIColor(named: "BackgroundPurple")
        self.detailCollectionView.delegate = self
        self.detailCollectionView.dataSource = self
        self.detailCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        self.detailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailCollectionView.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 20),
            self.detailCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.detailCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.detailCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        ])
    }
    
}

extension CalendarDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.calendarDetailViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath)
                        as? ListCollectionViewCell else { return UICollectionViewCell() }
        let gathering = self.calendarDetailViewModel[indexPath.item]
        cell.update(date: gathering.date, buddyImageList: gathering.buddyList.map{ $0.face }, typeList: gathering.purpose)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.detailCollectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell else { return }
        cell.animateButtonTap(scale: 0.9)
        
        self.dismiss(animated: true, completion: {
            self.delegate?.gatheringListTouched(self.calendarDetailViewModel[indexPath.item])
        })
    }
    
}

protocol GatheringListDelegate: AnyObject {
    func gatheringListTouched(_: Gathering)
}
