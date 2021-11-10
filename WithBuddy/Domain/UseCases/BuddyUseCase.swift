//
//  BuddyUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class BuddyUseCase {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchBuddy() -> [BuddyEntity] {
        return self.coreDataManager.fetch(request: BuddyEntity.fetchRequest())
    }
    
    func fetchBuddy(name: String) -> [BuddyEntity] {
        let request = BuddyEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        return self.coreDataManager.fetch(request: request)
    }
    
    func insertBuddy(_ buddy: Buddy) {
        self.coreDataManager.insertBuddy(buddy)
    }
}
