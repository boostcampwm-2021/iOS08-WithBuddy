//
//  CalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation
import Combine

final class CalendarViewModel {
    private let maxDayOfMonth = 42
    private let calendarUseCase: CalendarUseCase
    private let gatheringUseCase: GatheringUseCase
    private var thisMonthGathrtingList: [Gathering] = []
    
    
    private var totalFaces = [String]()
    private var calendarMonth: Date
    private var currentDate: Date
    
    private(set) var totalDays = [Int]()
    private(set) var todaySubject = PassthroughSubject<String, Never>()
    private(set) var didDaysReloadSignal = PassthroughSubject<Void, Never>()
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.calendarUseCase = CalendarUseCase()
        self.currentDate = Date()
        self.calendarMonth = self.calendarUseCase.firstTimeOfDay(baseDate: Date())
    }
    
    func viewDidAppear() {
        self.sendTodaySubject()
        self.reloadDays()
    }
    
    func didMonthButtonTouched(number: Int) {
        guard let month = self.calendarUseCase.changeMonth(self.calendarMonth, by: number) else { return }
        self.calendarMonth = month
        self.sendTodaySubject()
        self.reloadDays()
    }
    
    private func sendTodaySubject() {
        self.todaySubject.send(self.calendarUseCase.convertToString(month: self.calendarMonth))
    }
    
    private func reloadDays() {
        let numOfDaysInMonth = calendarUseCase.numOfDaysInMonth(baseDate: self.calendarMonth)
        let firstDayIndex = calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        
        self.totalDays = Array(repeating: 0, count: self.maxDayOfMonth)
        for index in 0..<numOfDaysInMonth {
            self.totalDays[index+firstDayIndex] = index + 1
        }
        self.didDaysReloadSignal.send()
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
        let weekDay = calendarUseCase.weekDay(baseDate: date)
        let maxDayOfMonth = 42
        
        self.totalDays.removeAll()
//        for count in 0..<maxDayOfMonth {
//            if count <= weekDay || numOfDaysInMonth + weekDay < count {
//                self.totalDays.append(0)
//            } else {
//                self.totalDays.append(count - weekDay)
//            }
//        }
    }
    
    func reloadFace(date: Date) {
        let maxDayOfMonth = 42
        self.totalFaces.removeAll()
        for _ in 0..<maxDayOfMonth {
            self.totalFaces.append("")
        }
        self.thisMonthGathrtingList.forEach {
            let blankDays = self.calendarUseCase.weekDay(baseDate: date)
            let day = Int(self.calendarUseCase.day(baseDate: $0.startDate)) ?? 0
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
            if self.calendarUseCase.firstTimeOfDay(baseDate: $0.startDate) == self.calendarUseCase.firstTimeOfDay(baseDate: date) {
                result = true
            }
        }
        return result
    }
    
}
