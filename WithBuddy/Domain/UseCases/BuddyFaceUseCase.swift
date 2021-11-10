//
//  BuddyFaceUseCase.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/07.
//

import Foundation

protocol BuddyFaceInterface {
    func faceList(color: String) -> [String]
    func insertBuddy(buddy: Buddy)
    func insertGathering(gathering: Gathering)
    func fetch() -> [Gathering]?
    func fetch(name: String) -> [Gathering]? 
    func random() -> String
}

final class BuddyFaceUseCase: BuddyFaceInterface {
    
    private let range = (1...9)
    
    func faceList(color: String) -> [String] {
        return self.range.map{ "\(color)\($0)" }
    }
    
    func insertBuddy(buddy: Buddy) {
        CoreDataManager.shared.insertBuddy(buddy)
    }
    
    func insertGathering(gathering: Gathering) {
        let buddyList = self.fetchBuddy().shuffled()
        CoreDataManager.shared.insertGathering(gathering, buddyList: buddyList)
    }
    
    private func fetchBuddy() -> [BuddyEntity] {
        let request = BuddyEntity.fetchRequest()
        return CoreDataManager.shared.fetch(request: request)
    }
    
    func fetch() -> [Gathering]? {
        let request = GatheringEntity.fetchRequest()
        let gatheringEntityList = CoreDataManager.shared.fetch(request: request)
        return gatheringEntityList.map{ Gathering(date: $0.date, place: $0.place, placeType: $0.placeType, buddy: $0.buddyList, memo: $0.memo, picture: $0.picture) }
    }
    
    func fetch(name: String) -> [Gathering]? {
        let request = GatheringEntity.fetchRequest()
        let predicate = NSPredicate(format: "%@ IN buddy.name", name)
        request.predicate = predicate
        let gatheringEntityList = CoreDataManager.shared.fetch(request: request)
        return gatheringEntityList.map{ Gathering(date: $0.date, place: $0.place, placeType: $0.placeType, buddy: $0.buddyList, memo: $0.memo, picture: $0.picture) }
    }
    
    func random() -> String {
        let colorList = [FaceColor.blue, FaceColor.green, FaceColor.pink, FaceColor.purple, FaceColor.red, FaceColor.yellow]
        guard let color = colorList.randomElement() else { return "FacePurple1" }
        let faceList = self.faceList(color: color)
        guard let index = self.range.randomElement() else { return "FacePurple1" }
        return faceList[index - 1]
    }
    
}
