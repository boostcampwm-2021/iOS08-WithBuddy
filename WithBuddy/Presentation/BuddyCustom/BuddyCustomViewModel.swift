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
        case .nameLength: return "버디의 이름은 2글자에서 10글자로 설정해주세요."
        }
    }
}

class BuddyCustomViewModel {
    private var id: UUID?
    @Published private(set) var name: String = ""
    @Published private(set) var face: Face = Face(color: .purple, number: 1)
    private(set) var addDoneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var editDoneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var failSignal = PassthroughSubject<BuddyCustomError, Never>()
    
    func buddyDidInserted(_ buddy: Buddy) {
        self.id = buddy.id
        self.name = buddy.name
        
        var buddyColor = buddy.face
        buddyColor.removeLast()
        for color in FaceColor.allCases where color.description == buddyColor {
            self.face.color = color
        }
        
        if let buddyFaceLastCharecter = buddy.face.last,
           let buddyFaceNumber = Int(String(buddyFaceLastCharecter)) {
            self.face.number = buddyFaceNumber
        }
    }
    
    func colorDidChosen(in idx: Int) {
        self.face.color = FaceColor.allCases[idx]
    }
    
    func faceDidChosen(in idx: Int) {
        self.face.number = idx + 1
    }
    
    func nameDidChaged(name: String) {
        self.name = name
    }
    
    func didDoneTouched() {
        if self.name.count < 2 {
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
