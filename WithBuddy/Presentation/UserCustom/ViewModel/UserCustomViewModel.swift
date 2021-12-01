//
//  UserCustomViewModel.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/12/01.
//

import Foundation
import Combine

final class UserCustomViewModel {
    
    @Published private(set) var name: String = ""
    @Published private(set) var face: Face = Face(color: .purple, number: 1)
    private(set) var createDoneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var failSignal = PassthroughSubject<BuddyCustomError, Never>()
    
    func didBuddyInserted(_ buddy: Buddy) {
        self.name = buddy.name
        
        let faceColor = buddy.face.filter({ $0.isLetter })
        for color in FaceColor.allCases where color.description == faceColor {
            self.face.color = color
        }
        
        if let faceNumber = Int(buddy.face.filter({ $0.isNumber })) {
            self.face.number = faceNumber
        }
    }
    
    func didColorChosend(in idx: Int) {
        self.face.color = FaceColor.allCases[idx]
    }
    
    func didFaceChosen(in idx: Int) {
        self.face.number = idx + 1
    }
    
    func didNameChaged(name: String) {
        self.name = name
    }
    
    func didDoneTouched() {
        if self.name.count < 2 {
            self.failSignal.send(BuddyCustomError.nameLength)
        } else {
            let newBuddy = Buddy(id: UUID(), name: self.name, face: "\(self.face)")
            self.createDoneSignal.send(newBuddy)
        }
    }
    
}
