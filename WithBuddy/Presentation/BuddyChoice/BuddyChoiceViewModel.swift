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
    
    var errorDescription: String? {
        switch self {
        case .noBuddy: return "최소 한명 이상의 버디를 추가해 주세요."
        }
    }
}

class BuddyChoiceViewModel {
    
    @Published private(set) var storedBuddyList: [Buddy] = []
    private(set) var doneSignal = PassthroughSubject<[Buddy], Never>()
    private(set) var failSignal = PassthroughSubject<BuddyChoiceError, Never>()
    private var checkedBuddyList: [Buddy] {
        return self.storedBuddyList.filter( {
            guard let check = $0.check else { return false }
            return check
        })
    }
    
    private var buddyUseCase = BuddyUseCase()
    
    func buddyDidADeleted(in idx: Int) {
        self.storedBuddyList.remove(at: idx)
    }
    
    func buddyDidAdded(_ buddy: Buddy) {
        self.buddyUseCase.insertBuddy(buddy)
        self.storedBuddyList.append(buddy)
    }
    
    func buddyDidChecked(in idx: Int) {
        if self.storedBuddyList[idx].check != nil {
            self.storedBuddyList[idx].check?.toggle()
        } else {
            self.storedBuddyList[idx].check = true
        }
    }
    
    func buddyListDidLoaded(by buddyList: [Buddy]) {
        let storedBuddyList = self.buddyUseCase.fetchBuddy()
        storedBuddyList.forEach( { buddy in
            var checkedBuddy = buddy
            checkedBuddy.check = true
            if buddyList.contains(checkedBuddy) {
                self.storedBuddyList.append(checkedBuddy)
            } else {
                self.storedBuddyList.append(buddy)            }
        })
    }
    
    func buddySelectingDidCompleted() {
        if self.checkedBuddyList.isEmpty {
            self.failSignal.send(BuddyChoiceError.noBuddy)
        } else {
            self.doneSignal.send(self.checkedBuddyList)
        }
    }
    
}
