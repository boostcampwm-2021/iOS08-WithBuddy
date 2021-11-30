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
    private var cancellable: Set<AnyCancellable> = []
    
    private(set) var selectedBuddy: Buddy?
    
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
    
    subscript(index: Int) -> Buddy {
        let buddy = self.buddyRank[index].0
        self.selectedBuddy = buddy
        return buddy
    }
    
    func viewWillAppear() {
        self.fetchBuddyRank()
        self.fetchPurposeRank()
        self.fetchLatestAndOldBuddy()
    }
    
    func didBuddyEdited(_ buddy: Buddy) {
        self.buddyUseCase.updateBuddy(buddy)
    }
    
    private func fetchBuddyRank() {
        self.buddyRank = Array(self.buddyUseCase.fetchBuddyRank(before: Date()).prefix(5))
    }
    
    private func fetchPurposeRank() {
        self.purposeUseCase.fetchTopFourPurpose(before: Date())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] rank in
                self?.purposeRank = rank.map{ ($0, self?.purposeUseCase.engToKor(eng: $0) ?? String()) }
            }).store(in: &self.cancellable)
    }
    
    private func fetchLatestAndOldBuddy() {
        let list = self.buddyUseCase.fetchBuddy(before: Date())
        self.oldBuddy = list.last
        self.latestBuddy = list.first
    }
    
}
