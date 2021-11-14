//
//  ChartViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/14.
//

import Foundation

final class ChartViewModel {
    
    @Published private(set) var buddyLank: [Buddy] = []
    @Published private(set) var purposeLank: [Purpose] = []
    @Published private(set) var latestBuddy: Buddy?
    @Published private(set) var oldBuddy: Buddy?
    private let gatheringUseCase: GatheringUseCase
    private let buddyUseCase: BuddyUseCase
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
        self.configure()
    }
    
    private func configure() {
        self.fetch()
    }
    
    func fetch() {
        let gatheringList = self.gatheringUseCase.fetchGathering()
        var buddyList = Set(self.buddyUseCase.fetchBuddy())
        
        if let lastGathering = gatheringList.first {
            self.latestBuddy = lastGathering.buddyList.first
        }
        
        gatheringList.forEach { gathering in
            gathering.buddyList.forEach { buddy in
                buddyList.remove(buddy)
                if buddyList.count == 1 {
                    self.oldBuddy = buddyList.first
                    return
                }
            }
            if buddyList.count == 1 { return }
        }
        
        if self.oldBuddy == nil {
            self.oldBuddy = gatheringList.last?.buddyList.last
        }
    }
    
}
