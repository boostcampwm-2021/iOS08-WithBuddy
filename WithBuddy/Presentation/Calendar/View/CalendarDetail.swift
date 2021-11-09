//
//  CalendarDetail.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import UIKit

class CalendarDetail: UIView {
    var selectedDate = Date()
    var detailLabel = UILabel()
    
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
        configureDetailLabel()
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
}
