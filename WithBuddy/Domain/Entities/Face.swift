//
//  Face.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/18.
//

import Foundation

struct Face: CustomStringConvertible {

    var color: FaceColor
    var number: Int
    var description: String {
        return "\(self.color.description)\(self.number)"
    }
    
}
