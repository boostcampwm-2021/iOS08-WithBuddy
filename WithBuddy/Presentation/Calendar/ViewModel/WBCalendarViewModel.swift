//
//  WBCalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation

final class WBCalendarViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private let calendarManager = CalendarManager()
    private let buddyFaceUseCase: BuddyFaceInterface
    private var thisMonthGathrtingList: [Gathering] = []
    
    init() {
        self.buddyFaceUseCase = BuddyFaceUseCase()
        self.configure()
    }
    
    var count: Int {
        return gatheringList.count
    }

    private func configure() {
        self.fetch()
    }
    
    private func fetch() {
        guard let gatheringList = self.buddyFaceUseCase.fetch() else { return }
        self.gatheringList = gatheringList
    }
    
    func firstBuddyFace(date: Date) -> String {
        var firstFace = ""
        self.thisMonthGathrtingList.forEach {
            if self.calendarManager.firstTimeOfMonth(baseDate: $0.startDate) == self.calendarManager.firstTimeOfMonth(baseDate: date) {
                if let face = $0.buddyList.first?.face {
                    firstFace = face
                }
            }
        }
        return firstFace
    }
    
    func thisMonthGatheringList(thisMonth: Date, numOfDays: Int) {
        self.thisMonthGathrtingList =  self.buddyFaceUseCase.fetch(thisMonth: thisMonth, numOfDays: numOfDays)
    }
    
    func isGathering(in date: Date) -> Bool {
        var result = false
        self.thisMonthGathrtingList.forEach {
            if self.calendarManager.firstTimeOfMonth(baseDate: $0.startDate) == self.calendarManager.firstTimeOfMonth(baseDate: date) {
                result = true
            }
        }
        return result
    }
    
}
