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
    private var name: String = ""
    private var faceColor: FaceColor = .purple
    private var faceNumber: Int = 1
    @Published private(set) var face: Face = Face(color: .purple, number: 1)
    private(set) var doneSignal = PassthroughSubject<Buddy, Never>()
    private(set) var failSignal = PassthroughSubject<BuddyCustomError, Never>()
    
    func colorDidChosen(in idx: Int) {
        self.faceColor = FaceColor.allCases[idx]
        self.face = Face(color: self.faceColor, number: self.faceNumber)
    }
    
    func faceDidChosen(in idx: Int) {
        self.faceNumber = idx + 1
        self.face = Face(color: self.faceColor, number: self.faceNumber)
    }
    
    func nameDidChaged(name: String) {
        self.name = name
    }
    
    func didDoneTouched() {
        if self.name.count < 3 {
            self.failSignal.send(BuddyCustomError.nameLength)
        } else {
            var newBuddy = Buddy(id: UUID(), name: self.name, face: "\(self.face)")
            if let id = self.id {
                newBuddy.id = id
            }
            self.doneSignal.send(newBuddy)
        }
    }
}
