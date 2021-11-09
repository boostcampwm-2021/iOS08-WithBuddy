//
//  CalendarDetail.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import UIKit

class CalendarDetailView: UIView {
    
    var selectedDate = Date()
    private var detailLabel = UILabel()
    private var detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let calendarDetailViewModel = CalendarDetailViewModel()
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 모임"
        self.detailLabel.text = dateFormatter.string(from: self.selectedDate)
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
        return self.calendarDetailViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath)
                as? ListCollectionViewCell else { return UICollectionViewCell() }
        let gathering = self.calendarDetailViewModel[indexPath.item]
        cell.update(date: gathering.date, buddyImageList: gathering.buddy.map { $0.face }, typeList: gathering.placeType )
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if totalDays[indexPath.item] > 0 {
//            self.selectedDate = self.calendarManager.pickDay(baseDate: selectedDate, numberOfDay: totalDays[indexPath.item])
//            self.delegate?.presentCellDetail(selectedDate: selectedDate)
////        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell {
            let pressedDownTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: { cell.transform = pressedDownTransform })
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell {
            let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: { cell.transform = originalTransform })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width-40, height: 150)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
}