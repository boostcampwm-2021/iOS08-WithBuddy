//
//  CalendarView.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/03.
//

import UIKit

class CalendarView: UIView {
    private let calendar = WBCalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configurCalendar()
    }
    
    private func configurCalendar() {
        self.addSubview(calendar)
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.calendar.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.calendar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }
}
