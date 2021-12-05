//
//  BuddyChoiceViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import Foundation
import Combine

final class BuddyChoiceViewModel {
    
    @Published private(set) var storedBuddyList: [Buddy] = []
    private(set) var doneSignal = PassthroughSubject<[Buddy], Never>()
    private(set) var failSignal = PassthroughSubject<CoreDataManager.CoreDataError, Never>()
    private(set) var deleteSuccessSignal = PassthroughSubject<Void, Never>()
    private var checkedBuddyList: [Buddy] {
        return self.storedBuddyList.filter( {
            guard let check = $0.check else { return false }
            return check
        })
    }
    
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
                //TODO: 성공 alert 처리 하기
                self?.storedBuddyList.append(buddy)
            }.store(in: &self.cancellable)
    }
    
    func didBuddyChecked(in idx: Int) {
        if self.storedBuddyList[idx].check != nil {
            self.storedBuddyList[idx].check?.toggle()
        } else {
            self.storedBuddyList[idx].check = true
        }
    }
    
    func didBuddyListLoaded(selectedBuddyList: [Buddy]) {
        self.buddyUseCase.fetchBuddy()
            .sink { completion in
                //TODO: 버디 목록 fetch 실패 처리 하기
                print(completion)
            } receiveValue: { [weak self] buddyList in
                self?.configureSelectedBuddy(selectedBuddyList: selectedBuddyList, to: buddyList)
            }.store(in: &self.cancellable)
    }
    
    func didBuddySelectingCompleted() {
        self.doneSignal.send(self.checkedBuddyList)
    }
    
    func didBuddyEdited(_ buddy: Buddy) {
        self.buddyUseCase.updateBuddy(buddy)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.failSignal.send(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] buddy in
                var editedBuddy = buddy
                guard let idx = self?.storedBuddyList.firstIndex(where: {
                    $0.id == buddy.id
                }) else { return }
                if let check = self?.storedBuddyList[idx].check,
                   check {
                    editedBuddy.check = true
                }
                //TODO: 성공 alert 처리 하기
                self?.storedBuddyList[idx] = editedBuddy
            }
            .store(in: &self.cancellable)
    }
    
    private func configureSelectedBuddy(selectedBuddyList: [Buddy], to buddyList: [Buddy]) {
        var storedBuddyList = [Buddy]()
        let idList = selectedBuddyList.map { $0.id }
        
        buddyList.forEach { buddy in
            if idList.contains(buddy.id) {
                var insertedBuddy = buddy
                insertedBuddy.check = true
                storedBuddyList.append(insertedBuddy)
            } else {
                storedBuddyList.append(buddy)
            }
        }
        self.storedBuddyList = storedBuddyList
    }
    
}
