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
    
    func didUserChanged(buddy: Buddy) {
        self.buddy = buddy
    }
    
    func startEditing() {
        self.editStartSignal.send(self.buddy)
    }
    
    func endEditing() {
        self.completeSignal.send(self.buddy)
        if let buddy = self.buddy {
            self.userUseCase.createUser(buddy: buddy)
        }
    }
    
}
