//
//  GatheringUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class GatheringUseCase {
    
    private let coreDataManager = CoreDataManager.shared
    
    func fetchGathering() -> [Gathering] {
        return self.coreDataManager.fetch(request: GatheringEntity.fetchRequest()).map{ $0.toDomain() }
    }
    
    func insertGathering(_ gathering: Gathering) {
        self.coreDataManager.insertGathering(gathering)
    }
    
}
