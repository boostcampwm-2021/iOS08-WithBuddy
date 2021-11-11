//
//  BuddyUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class BuddyUseCase {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchBuddy() -> [Buddy] {
        return self.coreDataManager.fetch(request: BuddyEntity.fetchRequest()).map{ $0.toDomain() }
    }
    
    func fetchBuddy(name: String) -> [Buddy] {
        let request = BuddyEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        return self.coreDataManager.fetch(request: request).map{ $0.toDomain() }
    }
    
    func insertBuddy(_ buddy: Buddy) {
        self.coreDataManager.insertBuddy(buddy)
    }
    
    func fetchGathering(name: String) -> [Gathering] {
        let request = BuddyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // [[GatherinEntity?]] -> [[GatheringEntity]] -> [GatheringEntity] -> [Gathering]
        return self.coreDataManager.fetch(request: request).map{ $0.gatheringList?.map{ $0 } }.compactMap{ $0 }.flatMap{ $0 }.map{ $0.toDomain() }
    }
}
