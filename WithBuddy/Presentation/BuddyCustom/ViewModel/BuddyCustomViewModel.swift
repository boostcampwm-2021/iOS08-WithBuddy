//
//  BuddyCustomViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/17.
//

import Foundation
import Combine

enum BuddyCustomError: LocalizedError {
    
    case nameLength
    
    var errorDescription: String? {
        switch self {
        case .nameLength: return "이름은 2글자에서 10글자로 설정해주세요."
        }
    }
    
}

final class BuddyCustomViewModel {
    
    let minNameLen = 2
    
    private var id: UUID?
    @Published private(set) var name: String = String()
    @Published private(set) var face: Face = Face(color: .purple, number: 1)
    private(set) var addDoneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var editDoneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var failSignal = PassthroughSubject<BuddyCustomError, Never>()
    
    func didBuddyInserted(_ buddy: Buddy) {
        self.id = buddy.id
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
        if self.name.count < self.minNameLen {
            self.failSignal.send(BuddyCustomError.nameLength)
        } else {
            var newBuddy = Buddy(id: UUID(), name: self.name, face: "\(self.face)")
            if let id = self.id {
                newBuddy.id = id
                self.editDoneSignal.send(newBuddy)
            } else {
                self.addDoneSignal.send(newBuddy)
            }
        }
    }
    
}
