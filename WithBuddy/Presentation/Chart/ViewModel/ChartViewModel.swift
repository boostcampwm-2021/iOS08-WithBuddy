//
//  ChartViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/14.
//

import Foundation

final class ChartViewModel {
    
    @Published private(set) var buddyLank: [Buddy] = []
    @Published private(set) var purposeLank: [String] = []
    @Published private(set) var latestBuddy: Buddy?
    @Published private(set) var oldBuddy: Buddy?
    
    private let gatheringUseCase: GatheringUseCase
    private let buddyUseCase: BuddyUseCase
    private var gatheringList: [Gathering] = []
    
    init() {
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
        self.buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
        self.configure()
    }
    
    private func configure() {
        self.fetch()
    }
    
    func fetch() {
        self.fetchPurposeLank()
        self.fetchLatestBuddy()
        self.fetchOldBuddy()
    }
    
    private func fetchPurposeLank() {
        var purposeMap = [String: Int]()
        
        self.gatheringList.forEach { gathering in
            gathering.purpose.forEach { purpose in
                if purposeMap.keys.contains(purpose) {
                    purposeMap[purpose]? += 1
                    
                } else {
                    purposeMap[purpose] = 1
                }
            }
        }
        
        let sortedPurposeList = purposeMap.sorted{ $0.value > $1.value }.map{ $0.key }
        let index = min(3, sortedPurposeList.count - 1)
        if Int.zero <= index {
            self.purposeLank = Array(sortedPurposeList[...index]).sorted{ $0 < $1 }
        }
    }

    private func fetchLatestBuddy() {
        self.gatheringList = self.gatheringUseCase.fetchGathering()
        if let lastGathering = self.gatheringList.first {
            self.latestBuddy = lastGathering.buddyList.first
        }
    }
    
    private func fetchOldBuddy() {
        var buddyList = Set(self.buddyUseCase.fetchBuddy())
        
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
