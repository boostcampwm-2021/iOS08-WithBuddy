//
//  CalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation
import Combine

final class CalendarViewModel {
    
    @Published private(set) var myFace: String?
    @Published private(set) var headerComment: String?
    
    private let calendarUseCase: CalendarUseCase
    private let gatheringUseCase: GatheringUseCase
    private let userUseCase: UserUseCase
    private var calendarMonth: Date
    private var currentDate: Date
    private var thisMonthGathrtingList = [Gathering]()
    
    private(set) var isSameMonth: Int?
    private(set) var totalDays = [Int]()
    private(set) var totalFaces = [String]()
    private(set) var totalGathering = [Int]()
    private(set) var monthSubject = PassthroughSubject<String, Never>()
    private(set) var didDaysReloadSignal = PassthroughSubject<Void, Never>()
    private(set) var didGatheringReloadSignal = PassthroughSubject<Void, Never>()
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.calendarUseCase = CalendarUseCase()
        self.userUseCase = UserUseCase()
        self.currentDate = Date()
        self.calendarMonth = self.calendarUseCase.firstTimeOfDay(baseDate: Date())
    }
    
    func viewWillAppear() {
        self.fetchBuddyFace()
        self.currentDate = Date()
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
        self.reloadTotalGathering()
        self.loadHeaderComment()
    }
    
    private func loadHeaderComment() {
        let gatheringList = self.gatheringUseCase.gatheringStatus(date: currentDate)
        var gatheringExist: [Int] = []
        var day = Date()
        for _ in Int.zero..<Int.maxDayOfMonth {
            gatheringExist.append(Int.zero)
        }
        for idx in Int.zero..<Int.maxDayOfMonth {
            gatheringList.forEach {
                if self.calendarUseCase.isSameDay(date1: $0.date, date2: day) {
                    gatheringExist[idx] = 1
                }
            }
            day = self.calendarUseCase.nextDay(baseDate: day)
        }
        self.headerComment = selectHeaderComment(gatheringExist: gatheringExist)
    }
    
    private func selectHeaderComment(gatheringExist: [Int]) -> String {
        let minContinuousDay = 2
        if gatheringExist[Int.zero] == 1 {
            return HeaderComments.gatheringToday.rawValue
        }
        for idx in (minContinuousDay...Int.numOfWeek).reversed() {
            if self.checkGathering(during: idx, gatheringExist: gatheringExist, status: .noGatheringStatus) {
                return "\(idx) \(HeaderComments.noGathering.rawValue)"
            }
        }
        for idx in (minContinuousDay...Int.numOfWeek).reversed() {
            if self.checkGathering(during: idx, gatheringExist: gatheringExist, status: .fullGatheringStatus) {
                return "\(idx) \(HeaderComments.fullGathering.rawValue)"
            }
        }
        return HeaderComments.everyDay.rawValue
    }
    
    private func checkGathering(during days: Int, gatheringExist: [Int], status: Int) -> Bool {
        var checkRange = (Int.zero...days-1)
        if status == .fullGatheringStatus {
            checkRange = (1...days)
        }
        for idx in checkRange where gatheringExist[idx] == status {
            return false
        }
        return true
    }
    
    func didMonthButtonTouched(number: Int) {
        guard let month = number == Int.zero ? Date() : self.calendarUseCase.changeMonth(self.calendarMonth, by: number) else { return }
        self.calendarMonth = month
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
        self.reloadTotalGathering()
    }
    
    func findDate(index: Int) -> Date {
        return self.calendarUseCase.makeDay(month: self.calendarMonth, day: self.totalDays[index])
    }
    
    private func fetchBuddyFace() {
        guard let buddy = self.userUseCase.fetchUser() else { return }
        self.myFace = buddy.face
    }
    
    private func sendMonthSubject() {
        self.monthSubject.send(self.calendarUseCase.convertToString(month: self.calendarMonth))
    }
    
    private func reloadDays() {
        let numOfDaysInMonth = calendarUseCase.numOfDaysInMonth(baseDate: self.calendarMonth)
        let firstDayIndex = calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.totalDays = Array(repeating: Int.zero, count: .maxDayOfMonth)
        
        for index in Int.zero..<numOfDaysInMonth {
            self.totalDays[index+firstDayIndex] = index + 1
        }
        
        self.isSameMonth = self.calendarUseCase.isSameDay(date1: self.calendarMonth, date2: self.currentDate) ? firstDayIndex + self.calendarUseCase.day(baseDate: self.currentDate) - 1 : nil
        
        self.didDaysReloadSignal.send()
    }
    
    func reloadFaces() {
        let firstDayIndex = self.calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.thisMonthGathrtingList = self.gatheringUseCase.fetchGathering(month: self.calendarMonth)
        self.totalFaces = Array(repeating: String(), count: .maxDayOfMonth)
        
        self.thisMonthGathrtingList.reversed().forEach {
            let day = self.calendarUseCase.day(baseDate: $0.date)
            if let face = $0.buddyList.sorted().first?.face {
                self.totalFaces[firstDayIndex + day - 1] = face
            }
        }
        self.didDaysReloadSignal.send()
    }
    
    func reloadTotalGathering() {
        self.totalGathering.removeAll()
        for _ in Int.zero..<Int.maxDayOfMonth {
            self.totalGathering.append(Int.zero)
        }
        
        let firstDayIndex = self.calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.thisMonthGathrtingList.forEach {
            let day = self.calendarUseCase.day(baseDate: $0.date)
            self.totalGathering[firstDayIndex + day - 1] += 1
        }
    }
    
}
