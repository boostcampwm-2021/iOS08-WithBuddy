//
//  GatheringUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class GatheringUseCase {
    
    private let coreDataManager: CoreDataManagable
    
    init(coreDataManager: CoreDataManagable) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchGathering() -> [Gathering] {
        return self.coreDataManager.fetchAllGathering().map{ $0.toDomain() }
    }
    
    func fetchGathering(including name: String) -> [Gathering] {
        return coreDataManager.fetchGathering(including: name).map{ $0.toDomain() }
    }
    
    func fetchGathering(including date: Date) -> [Gathering] {
        return coreDataManager.fetchGathering(including: date).map{ $0.toDomain() }
    }
    
    func fetchGathering(month: Date) -> [Gathering] {
        return coreDataManager.fetchGaterhing(month: month).map{ $0.toDomain() }
    }
    
    func insertGathering(_ gathering: Gathering) {
        self.coreDataManager.insertGathering(gathering)
    }
    
    func updateGathering(_ gathering: Gathering) {
        self.coreDataManager.updateGathering(gathering)
    }
    
    func deleteGathering(_ gatheringId: UUID) {
        self.coreDataManager.deleteGathering(gatheringId)
    }
    
}
