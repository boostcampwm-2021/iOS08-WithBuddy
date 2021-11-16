//
//  BuddyManageViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/16.
//

import Foundation
import Combine

class BuddyManageViewModel {
    
    @Published private(set) var storedBuddyList: [Buddy] = []
    
    private var buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
    
    func buddyDidDeleted(in idx: Int) {
        self.storedBuddyList.remove(at: idx)
    }
    
    func buddyDidAdded(_ buddy: Buddy) {
        self.buddyUseCase.insertBuddy(buddy)
        self.storedBuddyList.append(buddy)
    }
    
    func buddyListDidLoaded() {
        self.storedBuddyList = self.buddyUseCase.fetchBuddy()
    }
    
}
