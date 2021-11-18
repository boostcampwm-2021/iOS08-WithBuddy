//
//  BuddyCustomViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/17.
//

import Foundation
import Combine

class BuddyCustomViewModel {
    private var faceColor: FaceColor = .purple
    private var faceNumber: Int = 1
    @Published private(set) var face: Face = Face(color: .purple, number: 1)
    
    func colorDidChosen(in idx: Int) {
        self.faceColor = FaceColor.allCases[idx]
        self.face = Face(color: self.faceColor, number: self.faceNumber)
    }
    
    func faceDidChosen(in idx: Int) {
        self.faceNumber = idx + 1
        self.face = Face(color: self.faceColor, number: self.faceNumber)
    }
}
