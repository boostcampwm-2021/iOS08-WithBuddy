//
//  BuddyCustomViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/17.
//

import Foundation
import Combine

class BuddyCustomViewModel {
    @Published private(set) var color: FaceColor?
    
    func colorDidChosen(in idx: Int) {
        self.color = FaceColor.allCases[idx]
    }
}
