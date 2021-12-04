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
    private(set) var buddyEditSuccessSignal = PassthroughSubject<Void, Never>()
    private(set) var buddyEditFailSignal = PassthroughSubject<CoreDataManager.CoreDataError, Never>()
    
    private let gatheringUseCase: GatheringUseCase
    private let buddyUseCase: BuddyUseCaseProtocol
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
    
    func viewDidAppear() {
        self.fetchBuddyRank()
        self.fetchPurposeRank()
        self.fetchLatestAndOldBuddy()
    }
    
    func didBuddyEdited(_ buddy: Buddy) {
        self.buddyUseCase.updateBuddy(buddy)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.buddyEditFailSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] buddy in
                self?.buddyEditSuccessSignal.send()
            }.store(in: &self.cancellable)
    }
    
    private func fetchBuddyRank() {
        self.buddyUseCase.fetchBuddyRank(before: Date())
            .sink { completion in
                //TODO: 에러 처리 하기
                print(completion)
            } receiveValue: { [weak self] buddyRank in
                self?.buddyRank = Array(buddyRank.prefix(5))
            }.store(in: &self.cancellable)
    }
    
    private func fetchPurposeRank() {
        self.purposeUseCase.fetchTopFourPurpose(before: Date())
            .sink(receiveValue: { [weak self] rank in
                guard let self = self else { return }
                self.purposeRank = rank.map{ ($0, self.purposeUseCase.engToKor(eng: $0)) }
            }).store(in: &self.cancellable)
    }
    
    private func fetchLatestAndOldBuddy() {
        self.buddyUseCase.fetchBuddy(before: Date())
            .sink{ completion in
                //TODO: 에러 처리 하기
                print(completion)
            } receiveValue: { [weak self] buddyList in
                print(2, Thread.current.isMainThread)
                self?.oldBuddy = buddyList.last
                self?.latestBuddy = buddyList.first
            }.store(in: &self.cancellable)
    }
    
}
