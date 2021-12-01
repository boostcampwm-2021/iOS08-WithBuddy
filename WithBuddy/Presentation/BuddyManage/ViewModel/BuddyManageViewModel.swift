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
    
    func viewWillAppear() {
        self.didBuddyListLoaded()
    }
    
    func didBuddyDeleted(in idx: Int) {
        do {
            try self.buddyUseCase.deleteBuddy(storedBuddyList[idx])
            self.didBuddyListLoaded()
        } catch let error {
            guard let error = error as? BuddyChoiceError else { return }
            self.failSignal.send(error)
        }
    }
    
    private func didBuddyListLoaded() {
        self.storedBuddyList = self.buddyUseCase.fetchBuddy()
    }
    
}
