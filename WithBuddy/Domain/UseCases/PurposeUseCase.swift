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
    func engToKor(eng: String) -> String
}

final class PurposeUseCase: PurposeUseCaseProtocol {
    
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
        return Array(purposeEntity.map{ $0.name }.filter{ $0 != PurposeCategory.etc.description }.prefix(4))
    }
    
    func engToKor(eng: String) -> String {
        switch eng {
        case "Study": return "스터디"
        case "Shopping": return "쇼핑"
        case "Sport": return "운동"
        case "Healing": return "힐링"
        case "Hobby": return "취미생활"
        case "Culture": return "문화예술"
        case "ExtraCurricularActivities": return "대외활동"
        case "Meal": return "식사/카페"
        default: return "기타"
        }
    }
    
}
