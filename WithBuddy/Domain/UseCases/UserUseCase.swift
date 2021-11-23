//
//  UserUseCase.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/23.
//

import Foundation

final class UserUseCase {
    
    func createUser(buddy: Buddy) {
        do {
            let encodedData = try JSONEncoder().encode(buddy)
            UserDefaults.standard.set(encodedData, forKey: "buddy")
        } catch {
            return
        }
    }
    
    func fetchUser() -> Buddy? {
        do {
            guard let encodedData = UserDefaults.standard.data(forKey: "buddy") else { return nil }
            let buddy = try JSONDecoder().decode(Buddy.self, from: encodedData)
            return buddy
        } catch {
            return nil
        }
    }
    
}
