//
//  WBCalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation

final class WBCalendarViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private let gatheringUseCase: GatheringUseCase
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.configure()
    }
    
    var count: Int {
        return gatheringList.count
    }

    private func configure() {
        self.fetch()
    }
    
    private func fetch() {
        self.gatheringList = self.gatheringUseCase.fetchGathering()
    }
    
    func firstBuddyFace(selectedDate: Date) -> String {
        print("1111111", self.gatheringUseCase.fetchGathering(including: selectedDate))
        return self.gatheringUseCase.fetchGathering(including: selectedDate).first?.buddyList.first?.face ?? ""
    }
    
}
