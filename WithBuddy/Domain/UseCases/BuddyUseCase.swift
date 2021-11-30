//
//  BuddyUseCase.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/09.
//

import Foundation

final class BuddyUseCase {
    
    private let coreDataManager: CoreDataManagable
    
    init(coreDataManager: CoreDataManagable = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchBuddy() -> [Buddy] {
        return self.coreDataManager.fetchAllBuddy().map{ $0.toDomain() }
    }
    
    func fetchBuddy(name: String) -> [Buddy] {
        return self.coreDataManager.fetchBuddy(name: name).map{ $0.toDomain() }
    }
    
    func fetchBuddy(before date: Date) -> [Buddy] {
        return self.coreDataManager.fetchAllBuddy()
            .filter { $0.findRecentlyDate(before: date) != nil }
            .sorted { $0.findRecentlyDate(before: date) ?? Date() > $1.findRecentlyDate(before: date) ?? Date() }
            .map { $0.toDomain() }
    }
    
    func fetchBuddyRank(before date: Date) -> [(Buddy, Int)] {
        return self.coreDataManager.fetchAllBuddy()
            .map { ($0.toDomain(), $0.gatheringList.filter{ gathering in gathering.date <= date }.count) }
            .filter { $0.1 != Int.zero }
            .sorted{ $0.1 > $1.1 }
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
    
    func deleteBuddy(_ buddy: Buddy) throws {
        do {
            try self.coreDataManager.deleteBuddy(buddy)
        } catch {
            throw error
        }
    }
    
    private func makeRandomFace() -> String {
        let maxNumOfFace = 9
        let colorList = [FaceColor.blue, FaceColor.green, FaceColor.pink, FaceColor.purple, FaceColor.red, FaceColor.yellow]
        guard let color = colorList.randomElement() else { return "FacePurple" }
        guard let randomNumber = (1...maxNumOfFace).randomElement() else { return "FacePurple1" }
        
        return "\(color)\(randomNumber)"
    }
    
}
