//
//  BuddyUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class BuddyUseCase {
    
    private let coreDataManager: CoreDataManagable
    
    init(coreDataManager: CoreDataManagable) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchBuddy() -> [Buddy] {
        return self.coreDataManager.fetchAllBuddy().map{ $0.toDomain() }
    }
    
    func fetchBuddy(name: String) -> [Buddy] {
        return self.coreDataManager.fetchBuddy(name: name).map{ $0.toDomain() }
    }
    
    func insertBuddy(_ buddy: Buddy) {
        self.coreDataManager.insertBuddy(buddy)
    }
    
    func makeRandomBuddy() -> Buddy {
        let id = UUID()
        return Buddy(id: id,
                     name: id.uuidString,
                     face: self.makeRandomFace())
    }
    
    func updateBuddy(_ buddy: Buddy) {
        self.coreDataManager.updateBuddy(buddy)
    }
    
    private func makeRandomFace() -> String {
        let colorList = [FaceColor.blue, FaceColor.green, FaceColor.pink, FaceColor.purple, FaceColor.red, FaceColor.yellow]
        guard let color = colorList.randomElement() else { return "FacePurple1" }
        guard let randomNumber = (1...9).randomElement() else { return "FacePurple1" }
        
        return "\(color)\(randomNumber)"
    }
    
}
