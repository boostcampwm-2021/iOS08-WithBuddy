//
//  PlaceType.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

enum PlaceType: String, CaseIterable, CustomStringConvertible {
     
    case study = "Study"
    case shopping = "Shopping"
    case sport = "Sport"
    case healing = "Healing"
    case hobby = "Hobby"
    case culture = "Culture"
    case extracurricularActivities = "ExtraCurricularActivities"
    case meal = "Meal"
    case etc = "Etc"
    
    var description: String {
        return self.rawValue
    }
    
}
