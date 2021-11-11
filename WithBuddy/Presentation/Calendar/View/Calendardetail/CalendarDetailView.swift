//
//  CalendarDetail.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import UIKit

class CalendarDetailView: UIView {
    
    private var detailLabel = UILabel()
    private var detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let calendarDetailViewModel = CalendarDetailViewModel()
    
    var selectedDate = Date()
    weak var delegate: gatheringListDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureDetail()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureDetail()
    }
    
    func saveSelecetedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.configureDetail()
        self.detailCollectionView.reloadData()
    }
    
    private func configureDetail() {
        self.configureDetailLabel()
        self.configureDetailCollectionView()
    }
    
    func configureDetailLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 모임"
        self.detailLabel.text = dateFormatter.string(from: self.selectedDate)
        self.detailLabel.font = .boldSystemFont(ofSize: 20)
        self.detailLabel.textColor = UIColor(named: "LabelPurple")
        self.addSubview(detailLabel)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])
    }
    
    func configureDetailCollectionView() {
        self.detailCollectionView.backgroundColor = UIColor(named: "BackgroundPurple")
        self.addSubview(detailCollectionView)
        self.detailCollectionView.dataSource = self
        self.detailCollectionView.delegate = self
        self.detailCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        self.detailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailCollectionView.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 20),
            self.detailCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.detailCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.detailCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
}

extension CalendarDetailView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.calendarDetailViewModel.listOfDay(selectedDate: self.selectedDate)
        return self.calendarDetailViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        self.calendarDetailViewModel.listOfDay(selectedDate: self.selectedDate)
        let gathering = self.calendarDetailViewModel[indexPath.item]
        cell.update(date: gathering.startDate, buddyImageList: gathering.buddyList.map{ $0.face }, typeList: gathering.purpose)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell {
            cell.animateButtonTap(duration: 0.4, scale: 0.95)
            self.delegate?.gatheringListTouched()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width-40, height: 150)
    }
    
}

protocol gatheringListDelegate: AnyObject {
    func gatheringListTouched()
}
