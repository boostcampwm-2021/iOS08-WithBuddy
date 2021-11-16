//
//  CalendarDetailViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation

final class CalendarDetailViewModel {
    
    @Published private(set) var dayLabel: String = ""
    @Published private(set) var gatheringList: [Gathering] = []
    
    private let selectedDate: Date
    private let gatheringUseCase: GatheringUseCase
    private let calendarUseCase: CalendarUseCase
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.calendarUseCase = CalendarUseCase()
        self.dayLabel = self.calendarUseCase.convertToString(day: self.selectedDate)
    }
    
    var count: Int {
        return gatheringList.count
    }
    
    subscript(index: Int) -> Gathering {
        return self.gatheringList[index]
    }
    
    private func fetch() {
        self.gatheringList = self.gatheringUseCase.fetchGathering(including: self.selectedDate)
    }

}
