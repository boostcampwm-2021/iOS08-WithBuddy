//
//  BuddyChoiceViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import Foundation

class BuddyChoiceViewModel {
    @Published private(set) var storedBuddyList: [Buddy] = []
    
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
