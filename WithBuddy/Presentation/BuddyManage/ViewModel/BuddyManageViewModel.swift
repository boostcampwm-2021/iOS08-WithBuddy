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
    private(set) var failSignal = PassthroughSubject<BuddyChoiceError, Never>()
    private var buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
    
    subscript(index: Int) -> Buddy {
        return self.storedBuddyList[index]
    }
    
    func buddyDidDeleted(in idx: Int) {
        do {
            try self.buddyUseCase.deleteBuddy(storedBuddyList[idx])
            self.storedBuddyList.remove(at: idx)
        } catch let error {
            guard let error = error as? BuddyChoiceError else { return }
            self.failSignal.send(error)
        }
    }
    
    func buddyDidAdded(_ buddy: Buddy) {
        self.buddyUseCase.insertBuddy(buddy)
        self.storedBuddyList.append(buddy)
    }
    
    func buddyListDidLoaded() {
        self.storedBuddyList = self.buddyUseCase.fetchBuddy()
    }
    
    func buddyDidEdited(_ buddy: Buddy) {
        guard let idx = self.storedBuddyList.firstIndex(where: {
            $0.id == buddy.id
        }) else { return }
        self.storedBuddyList[idx] = buddy
        self.buddyUseCase.updateBuddy(buddy)
    }
    
}
