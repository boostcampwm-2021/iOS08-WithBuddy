//
//  FaceColor.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/07.
//

import Foundation

enum FaceColor: CaseIterable, CustomStringConvertible {
    
    case blue
    case green
    case pink
    case purple
    case red
    case yellow
    
    var description: String {
        switch self {
        case .blue: return "FaceBlue"
        case .green : return "FaceGreen"
        case .pink: return "FacePink"
        case .purple: return "FacePurple"
        case .red: return "FaceRed"
        case .yellow: return "FaceYellow"
        }
    }
    
}
