//
//  PurposeUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/22.
//

import Foundation
import Combine

protocol PurposeUseCaseProtocol {
    func fetchTopFourPurpose() -> AnyPublisher<[String], Never>
}

final class PurposeUseCase {
    
    private let coreDataManager: CoreDataManagable
    
    init(coreDataManager: CoreDataManagable = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchTopFourPurpose() -> AnyPublisher<[String], Never> {
        self.coreDataManager.fetchPurpose()
            .map{ self.convertPurposeEntity($0) }
            .eraseToAnyPublisher()
    }
    
    private func convertPurposeEntity(_ purposeEntity: [PurposeEntity]) -> [String] {
        return Array(purposeEntity.map{ $0.name }.filter{ $0 != PlaceType.etc.description }.prefix(4))
    }
    
}
