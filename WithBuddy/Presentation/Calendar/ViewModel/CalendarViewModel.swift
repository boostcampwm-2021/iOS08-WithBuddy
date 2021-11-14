//
//  WBCalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation

final class CalendarViewModel {
    
    private let calendarManager = CalendarManager()
    private let gatheringUseCase: GatheringUseCase
    private var thisMonthGathrtingList: [Gathering] = []
    private var totalDays = [Int]()
    private var totalFaces = [String]()
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    }
    
    var count: Int {
        return self.totalDays.count
    }
    
    var isFace: Bool {
        if self.totalFaces.isEmpty {
            return false
        }
        return true
    }
    
    func totalDays(index: Int) -> Int {
        return self.totalDays[index]
    }
    
    func totalFaces(index: Int) -> String {
        return self.totalFaces[index]
    }
    
    func reloadDays(date: Date) {
        let numOfDaysInMonth = calendarManager.numOfDaysInMonth(baseDate: date)
        let weekDay = calendarManager.weekDay(baseDate: date)
        let maxDayOfMonth = 42
        
        self.totalDays.removeAll()
        for count in 0..<maxDayOfMonth {
            if count <= weekDay || numOfDaysInMonth + weekDay < count {
                self.totalDays.append(0)
            } else {
                self.totalDays.append(count - weekDay)
            }
        }
    }
    
    func reloadFace(date: Date) {
        let maxDayOfMonth = 42
        self.totalFaces.removeAll()
        for _ in 0..<maxDayOfMonth {
            self.totalFaces.append("")
        }
        self.thisMonthGathrtingList.forEach {
            let blankDays = self.calendarManager.weekDay(baseDate: date)
            let day = Int(self.calendarManager.day(baseDate: $0.startDate)) ?? 0
            if let face = $0.buddyList.first?.face {
                self.totalFaces[blankDays + day] = face
            }
        }
    }
    
    func thisMonthGatheringList(thisMonth: Date, numOfDays: Int) {
        self.thisMonthGathrtingList =  self.gatheringUseCase.fetchGathering(month: thisMonth)
    }
    
    func isGathering(in date: Date) -> Bool {
        var result = false
        self.thisMonthGathrtingList.forEach {
            if self.calendarManager.firstTimeOfDay(baseDate: $0.startDate) == self.calendarManager.firstTimeOfDay(baseDate: date) {
                result = true
            }
        }
        return result
    }
    
}
