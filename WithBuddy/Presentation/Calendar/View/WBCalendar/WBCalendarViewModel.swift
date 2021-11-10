//
//  WBCalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation

final class WBCalendarViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private let buddyFaceUseCase: BuddyFaceInterface
    
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
    
    func firstBuddyFace(selectedDate: Date) -> String {
        return self.buddyFaceUseCase.fetchFirstFaceInOneDay(selectedDate: selectedDate)
    }
    
}
