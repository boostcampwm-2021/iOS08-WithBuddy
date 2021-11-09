//
//  PlaceType.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

enum PlaceType: Int, CaseIterable, CustomStringConvertible {
    
    case study = 0
    case shopping
    case sport
    case healing
    case hobby
    case culture
    case extracurricularActivities
    case meal
    case etc
    
    var description: String {
        switch self {
        case .study: return "Study"
        case .shopping: return "Shopping"
        case .sport: return "Sport"
        case .healing: return "Healing"
        case .hobby: return "Hobby"
        case .culture: return "Culture"
        case .extracurricularActivities: return "ExtraCurricularActivities"
        case .meal: return "Meal"
        case .etc: return "Etc"
        }
    }
    
}
