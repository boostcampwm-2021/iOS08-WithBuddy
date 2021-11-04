//
//  Buddy.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

struct Buddy: Hashable {
    private(set) var name: String
    
    init(name: String) {
        self.name = name
    }
}
