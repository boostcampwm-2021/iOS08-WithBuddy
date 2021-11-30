//
//  BuddyChoiceViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import Foundation
import Combine

enum BuddyChoiceError: LocalizedError {
    
    case noBuddy
    case oneMoreGathering
    
    var errorDescription: String? {
        switch self {
        case .noBuddy: return "최소 한명 이상의 버디를 추가해 주세요."
        case .oneMoreGathering: return "해당 버디가 한개 이상의 모임에 속해 있습니다."
        }
    }
    
}

final class BuddyChoiceViewModel {
    
    @Published private(set) var storedBuddyList: [Buddy] = []
    private(set) var doneSignal = PassthroughSubject<[Buddy], Never>()
    private(set) var failSignal = PassthroughSubject<BuddyChoiceError, Never>()
    private var checkedBuddyList: [Buddy] {
        return self.storedBuddyList.filter( {
            guard let check = $0.check else { return false }
            return check
        })
    }
    
    private var buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
    
    subscript(index: Int) -> Buddy {
        return self.storedBuddyList[index]
    }
    
    func didBuddyDeleted(in idx: Int) {
        do {
            try self.buddyUseCase.deleteBuddy(storedBuddyList[idx])
            self.storedBuddyList.remove(at: idx)
        } catch let error {
            guard let error = error as? BuddyChoiceError else { return }
            self.failSignal.send(error)
        }
    }
    
    func didBuddyAdded(_ buddy: Buddy) {
        self.buddyUseCase.insertBuddy(buddy)
        self.storedBuddyList.append(buddy)
    }
    
    func didBuddyChecked(in idx: Int) {
        if self.storedBuddyList[idx].check != nil {
            self.storedBuddyList[idx].check?.toggle()
        } else {
            self.storedBuddyList[idx].check = true
        }
    }
    
    func didBuddyListLoaded(by buddyList: [Buddy]) {
        let storedBuddyList = self.buddyUseCase.fetchBuddy()
        storedBuddyList.forEach( { buddy in
            var checkedBuddy = buddy
            checkedBuddy.check = true
            if buddyList.contains(checkedBuddy) || buddyList.contains(buddy) {
                self.storedBuddyList.append(checkedBuddy)
            } else {
                self.storedBuddyList.append(buddy)
            }
        })
    }
    
    func didBuddySelectingCompleted() {
        if self.checkedBuddyList.isEmpty {
            self.failSignal.send(BuddyChoiceError.noBuddy)
        } else {
            self.doneSignal.send(self.checkedBuddyList)
        }
    }
    
    func didBuddyEdited(_ buddy: Buddy) {
        guard let idx = self.storedBuddyList.firstIndex(where: {
            $0.id == buddy.id
        }) else { return }
        storedBuddyList[idx] = buddy
        self.buddyUseCase.updateBuddy(buddy)
    }
    
}
