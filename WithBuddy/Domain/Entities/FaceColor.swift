//
//  FaceColor.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/07.
//

import Foundation

enum FaceColor: CaseIterable, CustomStringConvertible {
    
    case purple
    case blue
    case green
    case pink
    case red
    case yellow
    
    var description: String {
        switch self {
        case .purple: return "FacePurple"
        case .blue: return "FaceBlue"
        case .green : return "FaceGreen"
        case .pink: return "FacePink"
        case .red: return "FaceRed"
        case .yellow: return "FaceYellow"
        }
    }
    
}
