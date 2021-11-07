//
//  BuddyFaceUseCase.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/07.
//

import Foundation

protocol BuddyFaceInterface {
    func faceList(color: String) -> [String]
    func random() -> String
}

final class BuddyFaceUseCase: BuddyFaceInterface {
    
    private let range = (1...9)
    
    func faceList(color: String) -> [String] {
        return self.range.map{ "\(color)\($0)" }
    }
    
    func random() -> String {
        let colorList = [FaceColor.blue, FaceColor.green, FaceColor.pink, FaceColor.purple, FaceColor.red, FaceColor.yellow]
        guard let color = colorList.randomElement() else { return "FacePurple1" }
        let faceList = self.faceList(color: color)
        guard let index = self.range.randomElement() else { return "FacePurple1" }
        return faceList[index - 1]
    }
    
}
