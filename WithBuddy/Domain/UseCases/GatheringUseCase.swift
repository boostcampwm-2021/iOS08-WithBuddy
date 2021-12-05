//
//  GatheringUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation
import Combine

protocol GatheringUseCaseProtocol {
    
    func fetchAllGathering() -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError>
    func fetchGathering(id: UUID) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError>
    func fetchGathering(day: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError>
    func fetchGathering(month: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError>
    func fetchGathering(oneWeekFrom date: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError>
    func insertGathering(_ gathering: Gathering) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError>
    func updateGathering(_ gathering: Gathering) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError>
    func deleteGathering(_ id: UUID) -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    func deleteAllGathering() -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    
}

final class GatheringUseCase: GatheringUseCaseProtocol {
    
    private let coreDataManager: GatheringManagable
    
    init(coreDataManager: GatheringManagable = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchAllGathering() -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchAllGathering()
            .map { gatheringEntityList in
                gatheringEntityList.map { $0.toDomain() }.sorted(by: >)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchGathering(id: UUID) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchGathering(id: id)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchGathering(day: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchGathering(day: day)
            .map { gatheringEntityList in
                gatheringEntityList.map { $0.toDomain() }.sorted(by: >)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchGathering(month: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchThisMonthGathering(month: month)
            .map { gatheringEntityList in
                gatheringEntityList.map { $0.toDomain() }.sorted()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchGathering(oneWeekFrom date: Date) -> AnyPublisher<[Gathering], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchGathering(oneWeekFrom: date)
            .map { gatheringEntityList in
                gatheringEntityList.map { $0.toDomain() }.sorted()
            }
            .eraseToAnyPublisher()
    }
    
    func insertGathering(_ gathering: Gathering) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError> {
        self.coreDataManager.insertGathering(gathering)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func updateGathering(_ gathering: Gathering) -> AnyPublisher<Gathering, CoreDataManager.CoreDataError> {
        self.coreDataManager.updateGathering(gathering)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func deleteGathering(_ id: UUID) -> AnyPublisher<Void, CoreDataManager.CoreDataError> {
        return self.coreDataManager.deleteGathering(id: id)
    }
    
    func deleteAllGathering() -> AnyPublisher<Void, CoreDataManager.CoreDataError> {
        return self.coreDataManager.deleteAllGathering()
    }
    
}
