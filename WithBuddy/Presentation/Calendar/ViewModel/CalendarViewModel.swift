//
//  CalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation
import Combine

final class CalendarViewModel {
    
    let maxDayOfMonth = 42
    private let calendarUseCase: CalendarUseCase
    private let gatheringUseCase: GatheringUseCase
    private var calendarMonth: Date
    private var currentDate: Date
    private var thisMonthGathrtingList = [Gathering]()
    
    private(set) var isSameMonth: Int?
    private(set) var totalDays = [Int]()
    private(set) var totalFaces = [String]()
    private(set) var monthSubject = PassthroughSubject<String, Never>()
    private(set) var didDaysReloadSignal = PassthroughSubject<Void, Never>()
    private(set) var didGatheringReloadSignal = PassthroughSubject<Void, Never>()
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.calendarUseCase = CalendarUseCase()
        self.currentDate = Date()
        self.calendarMonth = self.calendarUseCase.firstTimeOfDay(baseDate: Date())
    }
    
    func viewDidAppear() {
        self.currentDate = Date()
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
    }
    
    func didMonthButtonTouched(number: Int) {
        guard let month = number == 0 ? Date() : self.calendarUseCase.changeMonth(self.calendarMonth, by: number) else { return }
        self.calendarMonth = month
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
    }
    
    func findDate(index: Int) -> Date {
        self.calendarUseCase.makeDay(month: self.calendarMonth, day: self.totalDays[index])
    }
    
    private func sendMonthSubject() {
        self.monthSubject.send(self.calendarUseCase.convertToString(month: self.calendarMonth))
    }
    
    private func reloadDays() {
        let numOfDaysInMonth = calendarUseCase.numOfDaysInMonth(baseDate: self.calendarMonth)
        let firstDayIndex = calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.totalDays = Array(repeating: 0, count: self.maxDayOfMonth)
        
        for index in 0..<numOfDaysInMonth {
            self.totalDays[index+firstDayIndex] = index + 1
        }
        
        self.isSameMonth = self.calendarUseCase.month(baseDate: self.calendarMonth) == self.calendarUseCase.month(baseDate: self.currentDate) ? firstDayIndex + self.calendarUseCase.day(baseDate: self.currentDate) - 1 : nil
        
        self.didDaysReloadSignal.send()
    }
    
    func reloadFaces() {
        let firstDayIndex = self.calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.thisMonthGathrtingList = self.gatheringUseCase.fetchGathering(month: self.calendarMonth)
        self.totalFaces = Array(repeating: "", count: self.maxDayOfMonth)
        
        self.thisMonthGathrtingList.forEach {
            let day = self.calendarUseCase.day(baseDate: $0.date)
            if let face = $0.buddyList.sorted().first?.face {
                self.totalFaces[firstDayIndex + day - 1] = face
            }
        }
        
        self.didDaysReloadSignal.send()
    }
    
}
