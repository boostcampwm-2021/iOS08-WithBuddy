//
//  BuddyChoiceViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/09.
//

import Foundation

class BuddyChoiceViewModel {
    @Published private(set) var buddyList: [Buddy] = []
    
    func buddyDidAdded(_ buddy: Buddy) {
        self.buddyList.append(buddy)
    }
    
    func buddyDidUpdated(_ buddyList: [Buddy]) {
        buddyList.forEach({
            self.buddyList.append($0)
        })
    }
}
