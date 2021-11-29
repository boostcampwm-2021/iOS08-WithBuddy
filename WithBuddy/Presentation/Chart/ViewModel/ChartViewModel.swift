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
    @Published private(set) var purposeRank: [(String, String)] = []
    @Published private(set) var latestBuddy: Buddy?
    @Published private(set) var oldBuddy: Buddy?
    
    private let gatheringUseCase: GatheringUseCase
    private let buddyUseCase: BuddyUseCase
    private let purposeUseCase: PurposeUseCaseProtocol
    private let userUseCase: UserUseCase
    private var gatheringList: [Gathering] = []
    private var buddyList: [Buddy] = []
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        gatheringUseCase: GatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        buddyUseCase: BuddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared),
        purposeUseCase: PurposeUseCase = PurposeUseCase(coreDataManager: CoreDataManager.shared),
        userUseCase: UserUseCase = UserUseCase()
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.buddyUseCase = buddyUseCase
        self.purposeUseCase = purposeUseCase
        self.userUseCase = userUseCase
    }
    
    func fetch() {
        self.fetchGatheringAndBuddy()
        self.fetchBuddyRank()
        self.fetchPurposeRank()
        self.fetchLatestAndOldBuddy()
    }
    
    private func fetchGatheringAndBuddy() {
        self.gatheringList = self.gatheringUseCase.fetchGathering()
        self.buddyList = self.buddyUseCase.fetchBuddy()
    }
    
    private func fetchBuddyRank() {
        self.buddyRank = Array(self.buddyUseCase.fetchBuddyRank(before: Date()).prefix(5))
    }
    
    private func fetchPurposeRank() {
        self.purposeUseCase.fetchTopFourPurpose(before: Date())
            .sink(receiveValue: { rank in
                self.purposeRank = rank.map{ ($0, self.purposeUseCase.engToKor(eng: $0)) }
            }).store(in: &self.cancellable)
    }
    
    private func fetchLatestAndOldBuddy() {
        let list = self.buddyUseCase.fetchBuddy(before: Date())
        self.oldBuddy = list.last
        self.latestBuddy = list.first
    }
    
}
