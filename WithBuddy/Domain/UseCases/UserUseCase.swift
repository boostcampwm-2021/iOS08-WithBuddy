//
//  UserUseCase.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/23.
//

import Foundation

final class UserUseCase {
    
    func createUser(name: String, face: String) {
        // UserDafault에 정보생성
    }
    
    func fetchUser() -> Buddy? {
        // UserDefault로부터 정보 불러오기
        return nil
    }
    
    func changeUser(name: String, face: String) {
        // User 정보 바꿔서 저장하기
    }
    
}
