//
//  ListViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import Foundation

final class ListViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private(set) var searchedList: [Gathering] = []
    private(set) var isSearched: Bool = false
    
    private let buddyUseCase: BuddyUseCase
    private let gatheringUseCase: GatheringUseCase
    
    init(buddyUseCase: BuddyUseCase, gatheringUseCase: GatheringUseCase) {
        self.buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
        self.gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    }
    
    var count: Int {
        return gatheringList.count
    }
    
    subscript(index: Int) -> Gathering {
        if self.isSearched {
            return self.searchedList[index]
        }
        return self.gatheringList[index]
    }
    
    func viewWillAppear() {
        self.gatheringList = self.gatheringUseCase.fetchGathering()
        self.isSearched = false
    }
    
    func didBuddySearched(list: [Gathering]) {
        if list.isEmpty {
            self.isSearched = false
            return
        }
        self.isSearched = true
        self.searchedList = list
    }
    
    func didGatheringDeleted(index: Int) {
        let gathering = self.gatheringList.remove(at: index)
        self.gatheringUseCase.deleteGathering(gathering.id)
    }
    
}
