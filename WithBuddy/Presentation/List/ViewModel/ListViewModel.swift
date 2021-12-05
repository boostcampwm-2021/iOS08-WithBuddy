//
//  ListViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import Foundation
import Combine

final class ListViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private(set) var searchedList: [Gathering] = []
    private(set) var isSearched: Bool = false
    private(set) var deleteSuccessSignal = PassthroughSubject<Gathering, Never>()
    
    private let gatheringUseCase: GatheringUseCaseProtocol
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        gatheringUseCase: GatheringUseCaseProtocol = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    ) {
        self.gatheringUseCase = gatheringUseCase
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
        self.gatheringUseCase.fetchAllGathering()
            .sink { completion in
                //TODO: gathering fetch error alert하기
                print(completion)
            } receiveValue: { [weak self] gatheringList in
                self?.gatheringList = gatheringList
                self?.isSearched = false
            }
            .store(in: &self.cancellable)
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
        self.gatheringUseCase.deleteGathering(self.gatheringList[index].id)
            .sink { completion in
                //TODO: gathering delete error alert하기
                print(completion)
            } receiveValue: { [weak self] in
                guard let gathering = self?.gatheringList.remove(at: index) else { return }
                self?.deleteSuccessSignal.send(gathering)
            }
            .store(in: &self.cancellable)
    }
    
}
