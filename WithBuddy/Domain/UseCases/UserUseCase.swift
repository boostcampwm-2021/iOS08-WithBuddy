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
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: buddy, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "buddy")
        } catch {
            return
        }
    }
    
    func fetchUser() -> Buddy? {
        do {
            guard let encodedData = UserDefaults.standard.data(forKey: "buddy"),
                  let buddy = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as? Buddy else { return nil }
            return buddy
        } catch {
            return nil
        }
    }
    
}
