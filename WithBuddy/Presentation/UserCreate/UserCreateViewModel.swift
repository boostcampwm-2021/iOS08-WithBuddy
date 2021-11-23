//
//  UserCreateViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/22.
//

import Foundation
import Combine

final class UserCreateViewModel {
    
    @Published private(set) var buddy: Buddy?
    private(set) var editStartSignal = PassthroughSubject<Buddy?, Never>()
    private(set) var completeSignal = PassthroughSubject<Buddy?, Never>()
    
    private var userUseCase = UserUseCase()
    
    func userDidChanged(buddy: Buddy) {
        self.buddy = buddy
    }
    
    func editStart() {
        self.editStartSignal.send(self.buddy)
    }
    
    func createComplte() {
        self.completeSignal.send(self.buddy)
        if let buddy = self.buddy {
            self.userUseCase.createUser(buddy: buddy)
        }
    }
    
}
