//
//  PlaceType.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

enum PurposeCategory: String, CaseIterable {
     
    case study = "Study"
    case shopping = "Shopping"
    case sport = "Sport"
    case healing = "Healing"
    case hobby = "Hobby"
    case culture = "Culture"
    case extracurricularActivities = "ExtraCurricularActivities"
    case meal = "Meal"
    case etc = "Etc"
    
}

extension PurposeCategory: CustomStringConvertible {
    
    var description: String {
        return self.rawValue
    }
    
}

extension PurposeCategory: Comparable {
    
    static func < (lhs: PurposeCategory, rhs: PurposeCategory) -> Bool {
        return lhs.order < rhs.order
    }
    
    
    private var order: Int {
        switch self {
        case .study: return 0
        case .shopping : return 1
        case .sport: return 2
        case .healing: return 3
        case .hobby: return 4
        case .culture: return 5
        case .extracurricularActivities: return 6
        case .meal: return 7
        case .etc: return 8
        }
    }
    
    
    
}
