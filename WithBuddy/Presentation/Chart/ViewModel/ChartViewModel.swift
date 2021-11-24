//
//  ChartViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/14.
//

import Foundation
import Combine

final class ChartViewModel {
    
    @Published private(set) var buddyRank: [(Buddy, Int)] = []
    @Published private(set) var purposeRank: [String] = []
    @Published private(set) var latestBuddy: Buddy?
    @Published private(set) var oldBuddy: Buddy?
    
    private let gatheringUseCase: GatheringUseCase
    private let buddyUseCase: BuddyUseCase
    private let purposeUseCase: PurposeUseCaseProtocol
    private var gatheringList: [Gathering] = []
    private var buddyList: [Buddy] = []
    
    init(
        gatheringUseCase: GatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        buddyUseCase: BuddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared),
        purposeUseCase: PurposeUseCase = PurposeUseCase(coreDataManager: CoreDataManager.shared)
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.buddyUseCase = buddyUseCase
        self.purposeUseCase = purposeUseCase
        self.fetch()
    }
    
    func fetch() {
        self.fetchGatheringAndBuddy()
        self.fetchBuddyRank()
        self.fetchPurposeRank()
        self.fetchLatestBuddy()
        self.fetchOldBuddy()
    }
    
    private func fetchGatheringAndBuddy() {
        self.gatheringList = self.gatheringUseCase.fetchGathering()
        self.buddyList = self.buddyUseCase.fetchBuddy()
    }
    
    private func fetchBuddyRank() {
        var buddyMap: [Buddy: Int] = [:]
        self.buddyList.forEach { buddy in
            buddyMap[buddy] = 0
        }
        
        self.gatheringList.forEach { gathering in
            gathering.buddyList.forEach { buddy in
                buddyMap[buddy]? += 1
            }
        }
        
        let sortedBuddyList = buddyMap.sorted{
            if $0.value == $1.value { return $0.key.name < $1.key.name }
            return $0.value > $1.value
        }
        let index = min(5, sortedBuddyList.count - 1)
        if Int.zero <= index {
            self.buddyRank = Array(sortedBuddyList[...index].filter{ $0.value != Int.zero }.map{ ($0.key, $0.value) })
        }
    }
    
    private func fetchPurposeRank() {
        self.purposeUseCase.fetchTopFourPurpose()
            .sink(receiveValue: { rank in
                self.purposeRank = rank
            }).cancel()
    }
    
    private func fetchLatestBuddy() {
        let currentDate = Date()
        for gathering in self.gatheringList where gathering.date < currentDate {
            self.latestBuddy = gathering.buddyList.first
            return
        }
        self.latestBuddy = nil
    }
    
    private func fetchOldBuddy() {
        var buddyList = Set(self.buddyList)
        
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
            return
        }
    }
    
}
