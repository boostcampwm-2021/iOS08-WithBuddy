//
//  Buddy.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

struct Buddy: Hashable {
    var id: UUID
    var name: String
    var face: String
    var check: Bool?
}

extension Buddy: Comparable {
    
    static func < (lhs: Buddy, rhs: Buddy) -> Bool {
        return lhs.name < rhs.name
    }
    
}
