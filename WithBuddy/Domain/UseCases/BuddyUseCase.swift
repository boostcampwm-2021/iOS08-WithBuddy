//
//  BuddyUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation
import Combine

protocol BuddyUseCaseProtocol {
    
    func fetchBuddy() -> AnyPublisher<[Buddy], CoreDataManager.CoreDataError>
    func fetchBuddy(before date: Date) -> AnyPublisher<[Buddy], CoreDataManager.CoreDataError>
    func fetchBuddyRank(before date: Date) -> AnyPublisher<[(Buddy, Int)], CoreDataManager.CoreDataError>
    func insertBuddy(_ buddy: Buddy) -> AnyPublisher<Buddy, CoreDataManager.CoreDataError>
    func updateBuddy(_ buddy: Buddy) -> AnyPublisher<Buddy, CoreDataManager.CoreDataError>
    func deleteBuddy(_ buddy: Buddy) -> AnyPublisher<Void, CoreDataManager.CoreDataError>
    
}

final class BuddyUseCase: BuddyUseCaseProtocol {
    
    private let coreDataManager: BuddyManagable
    
    init(coreDataManager: BuddyManagable = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchBuddy() -> AnyPublisher<[Buddy], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchAllBuddy()
            .map{ buddyEntityList in buddyEntityList.map{ $0.toDomain() }.sorted() }
            .eraseToAnyPublisher()
    }
    
    func fetchBuddy(before date: Date) -> AnyPublisher<[Buddy], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchAllBuddy()
            .map{ buddyEntityList in
                buddyEntityList
                .filter{ $0.findRecentlyDate(before: date) != nil}
                .sorted { $0.findRecentlyDate(before: date) ?? Date() > $1.findRecentlyDate(before: date) ?? Date() }
                .map { $0.toDomain() }
                .sorted()
            }.eraseToAnyPublisher()
    }
    
    func fetchBuddyRank(before date: Date) -> AnyPublisher<[(Buddy, Int)], CoreDataManager.CoreDataError> {
        self.coreDataManager.fetchAllBuddy()
            .map{ buddyEntityList in
                buddyEntityList
                .map{ ($0.toDomain(), $0.gatheringList.filter{ gathering in gathering.date <= date }.count) }
                .filter{ $0.1 != Int.zero }
                .sorted{ $0.1 > $1.1 }
            }.eraseToAnyPublisher()
    }
    
    func insertBuddy(_ buddy: Buddy) -> AnyPublisher<Buddy, CoreDataManager.CoreDataError> {
        self.coreDataManager.insertBuddy(buddy)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func updateBuddy(_ buddy: Buddy) -> AnyPublisher<Buddy, CoreDataManager.CoreDataError> {
        self.coreDataManager.updateBuddy(buddy)
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func deleteBuddy(_ buddy: Buddy) -> AnyPublisher<Void, CoreDataManager.CoreDataError> {
        self.coreDataManager.deleteBuddy(buddy)
            .eraseToAnyPublisher()
    }
    
}
