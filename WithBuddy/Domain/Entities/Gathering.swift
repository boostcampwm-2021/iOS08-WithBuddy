//
//  Gathering.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/08.
//

import Foundation

struct Gathering: Hashable {
    var date: Date
    var place: String?
    var placeType: [Int]
    var buddy: [Buddy]
    var memo: String?
    var picture: [URL]?
}
