//
//  CalendarUseCase.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/04.
//

import Foundation

final class CalendarUseCase {
    
    private let calendar = Calendar.current
    
    func changeMonth(_ month: Date, by number: Int) -> Date? {
        return self.calendar.date(byAdding: .month, value: number, to: month)
    }
    
    func convertToString(month: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: month)
    }
    
    func findFirstDayIndex(of month: Date) -> Int {
        let firstDay = self.firstDateOfMonth(baseDate: month)
        return self.weekDay(baseDate: firstDay)
    }
    
    func firstTimeOfDay(baseDate: Date) -> Date {
        return calendar.startOfDay(for: baseDate)
    }
    
    func firstDateOfMonth(baseDate: Date) -> Date {
        let components = self.calendar.dateComponents([.year, .month], from: baseDate)
        return self.calendar.date(from: components) ?? Date()
    }
    
    func numOfDaysInMonth(baseDate: Date) -> Int {
        guard let range = self.calendar.range(of: .day, in: .month, for: baseDate) else { return 0 }
        return range.count
    }
    
    func weekDay(baseDate: Date) -> Int {
        let components = self.calendar.dateComponents([.weekday], from: baseDate)
        return (components.weekday ?? 1) - 1
    }
    
    func pickDay(baseDate: Date, numberOfDay: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDay - 1
        return self.calendar.date(byAdding: dateComponents, to: baseDate) ?? Date()
    }
    
    func month(baseDate: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return Int(dateFormatter.string(from: baseDate)) ?? 0
    }
    
    func day(baseDate: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return Int(dateFormatter.string(from: baseDate)) ?? 0
    }
    
}
