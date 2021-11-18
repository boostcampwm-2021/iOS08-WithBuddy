//
//  BuddyCustomViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/17.
//

import Foundation
import Combine

class BuddyCustomViewModel {
    @Published private(set) var faceColor: FaceColor = FaceColor.purple
    @Published private(set) var faceNumber: Int = 1
    @Published private(set) var face: String = "\(FaceColor.purple)1"
    
    func colorDidChosen(in idx: Int) {
        self.faceColor = FaceColor.allCases[idx]
        self.face = FaceColor.allCases[idx].description + "\(faceNumber)"
    }
    
    func faceDidChosen(in idx: Int) {
        self.faceNumber = idx + 1
        self.face = faceColor.description + "\(idx + 1)"
    }
}
