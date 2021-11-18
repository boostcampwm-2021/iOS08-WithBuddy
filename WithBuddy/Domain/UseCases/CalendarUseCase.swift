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
    
    func convertToString(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        return dateFormatter.string(from: day)
    }
    
    func findFirstDayIndex(of month: Date) -> Int {
        let firstDay = self.firstDateOfMonth(baseDate: month)
        return self.weekDay(baseDate: firstDay)
    }
    
    func firstTimeOfDay(baseDate: Date) -> Date {
        return calendar.startOfDay(for: baseDate)
    }
    
    func nextDay(baseDate: Date) -> Date {
        return self.calendar.date(byAdding: DateComponents(day: 1), to: baseDate) ?? Date()
    }
    
    func firstDateOfMonth(baseDate: Date) -> Date {
        let components = self.calendar.dateComponents([.year, .month], from: baseDate)
        return self.calendar.date(from: components) ?? Date()
    }
    
    func nextMonth(baseDate: Date) -> Date {
        return self.calendar.date(byAdding: DateComponents(month: 1), to: baseDate) ?? Date()
    }
    
    func numOfDaysInMonth(baseDate: Date) -> Int {
        guard let range = self.calendar.range(of: .day, in: .month, for: baseDate) else { return 0 }
        return range.count
    }
    
    func weekDay(baseDate: Date) -> Int {
        let components = self.calendar.dateComponents([.weekday], from: baseDate)
        return (components.weekday ?? 1) - 1
    }
    
    func makeDay(month: Date, day: Int) -> Date {
        return self.calendar.date(
            byAdding: .day,
            value: day - 1,
            to: firstDateOfMonth(baseDate: month)
        ) ?? Date()
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
