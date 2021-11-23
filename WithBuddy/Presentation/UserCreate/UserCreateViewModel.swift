//
//  UserCreateViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/22.
//

import Foundation
import Combine

final class UserCreateViewModel {
    
    @Published private(set) var user: Buddy?
    private(set) var editStartSignal = PassthroughSubject<Buddy?, Never>()
    
    func userDidChanged(user: Buddy) {
        self.user = user
    }
    
    func editStart() {
        self.editStartSignal.send(self.user)
    }
    
}
