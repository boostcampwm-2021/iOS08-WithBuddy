//
//  BuddyManageViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/16.
//

import Foundation
import Combine

final class BuddyManageViewModel {
    
    @Published private(set) var storedBuddyList: [Buddy] = []
    private(set) var deleteSuccessSignal = PassthroughSubject<Void, Never>()
    private(set) var failSignal = PassthroughSubject<CoreDataManager.CoreDataError, Never>()
    private var buddyUseCase: BuddyUseCaseProtocol
    private var cancellable: Set<AnyCancellable> = []
    
    init(buddyUseCase: BuddyUseCaseProtocol = BuddyUseCase(coreDataManager: CoreDataManager.shared)) {
        self.buddyUseCase = buddyUseCase
    }
    
    subscript(index: Int) -> Buddy {
        return self.storedBuddyList[index]
    }
    
    func didBuddyDeleted(in idx: Int) {
        self.buddyUseCase.deleteBuddy(self.storedBuddyList[idx])
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.failSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] in
                self?.storedBuddyList.remove(at: idx)
                self?.deleteSuccessSignal.send()
            }
            .store(in: &self.cancellable)
    }
    
    func didBuddyAdded(_ buddy: Buddy) {
        self.buddyUseCase.insertBuddy(buddy)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.failSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] buddy in
                //TODO: 성공 alert 처리하기
                self?.storedBuddyList.append(buddy)
            }.store(in: &self.cancellable)
    }
    
    func didBuddyListLoaded() {
        self.buddyUseCase.fetchBuddy()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.failSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] buddyList in
                //TODO: 성공 alert 처리하기
                self?.storedBuddyList = buddyList
            }.store(in: &self.cancellable)
    }
    
    func buddyDidEdited(_ buddy: Buddy) {
        guard let idx = self.storedBuddyList.firstIndex(where: {
            $0.id == buddy.id
        }) else { return }
        
        self.buddyUseCase.updateBuddy(buddy)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.failSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] buddy in
                //TODO: 성공 처리 alert 처리하기
                self?.storedBuddyList[idx] = buddy
            }
            .store(in: &self.cancellable)
    }
    
}
