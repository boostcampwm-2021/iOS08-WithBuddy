//
//  WBCalendar.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class WBCalendarView: UIView {
    private let calendarHeader = WBCalendarHeaderView()
    private let calendarBody = WBCalenderBodyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureWBCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureWBCalendar()
    }
    
    private func configureWBCalendar() {
        self.addSubview(calendarHeader)
        self.addSubview(calendarBody)
        self.calendarHeader.translatesAutoresizingMaskIntoConstraints = false
        self.calendarBody.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarHeader.topAnchor.constraint(equalTo: self.topAnchor),
            self.calendarHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.calendarHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.calendarHeader.heightAnchor.constraint(equalToConstant: 80),
            self.calendarBody.topAnchor.constraint(equalTo: self.calendarHeader.bottomAnchor),
            self.calendarBody.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.calendarBody.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.calendarBody.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
