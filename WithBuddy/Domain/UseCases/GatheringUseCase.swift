//
//  GatheringUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class GatheringUseCase {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchGathering() -> [GatheringEntity] {
        return self.coreDataManager.fetch(request: GatheringEntity.fetchRequest())
    }
    
    func insertGathering(_ gathering: Gathering, buddy: [Buddy]) {
        let buddyList = self.coreDataManager.fetch(request: BuddyEntity.fetchRequest())
//        dump(buddyList)
        let buddyMap = buddy.map { $0.id }
//        dump(buddyMap)
        let filter = buddyList.filter{ buddyMap.contains($0.id) }
//        dump(filter)
        self.coreDataManager.insertGathering(gathering, buddyList:  filter)
    }
}
