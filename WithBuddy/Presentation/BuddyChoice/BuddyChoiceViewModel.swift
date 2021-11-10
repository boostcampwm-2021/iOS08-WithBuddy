//
//  BuddyChoiceViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import Foundation

class BuddyChoiceViewModel {
    @Published private(set) var storedBuddyList: [Buddy] = []
    private var checkedBuddyList: [Buddy] {
        return self.storedBuddyList.filter( {
            guard let check = $0.check else { return false }
            return check
        })
    }
    
    func buddyDidADeleted(in idx: Int) {
        self.storedBuddyList.remove(at: idx)
    }
    
    func buddyDidAdded(_ buddy: Buddy) {
        self.storedBuddyList.append(buddy)
    }
    
    func buddyDidUpdated(_ buddyList: [Buddy]) {
        buddyList.forEach({
            self.storedBuddyList.append($0)
        })
    }
    
    func buddyDidChecked(in idx: Int) {
        if let _ = self.storedBuddyList[idx].check {
            self.storedBuddyList[idx].check?.toggle()
        } else {
            self.storedBuddyList[idx].check = true
        }
    }
}
