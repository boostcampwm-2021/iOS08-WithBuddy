//
//  CalendarManager.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/04.
//

import Foundation

final class CalendarManager {
    
    private let calendar = Calendar.current
    
    func plusMonth(baseDate: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        return self.calendar.date(byAdding: dateComponents, to: baseDate) ?? Date()
    }
    
    func minusMonth(baseDate: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return self.calendar.date(byAdding: dateComponents, to: baseDate) ?? Date()
    }
    
    func pickDay(baseDate: Date, numberOfDay: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDay - 1
        return self.calendar.date(byAdding: dateComponents, to: baseDate) ?? Date()
    }
    
    func month(baseDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: baseDate)
    }
    
    func year(baseDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: baseDate)
    }
    
    func day(baseDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: baseDate)
    }
    
    func numOfDaysInMonth(baseDate: Date) -> Int {
        guard let range = self.calendar.range(of: .day, in: .month, for: baseDate) else { return 0 }
        return range.count
    }
    
    func firstDateOfMonth(baseDate: Date) -> Date {
        let components = self.calendar.dateComponents([.year, .month], from: baseDate)
        return self.calendar.date(from: components) ?? Date()
    }
    
    func firstTimeOfDay(baseDate: Date) -> Date {
        let components = self.calendar.dateComponents([.year, .month, .day], from: baseDate)
        return self.calendar.date(from: components) ?? Date()
    }
    
    func weekDay(baseDate: Date) -> Int {
        let components = self.calendar.dateComponents([.weekday], from: baseDate)
        return (components.weekday ?? 1) - 1
    }
    
}
