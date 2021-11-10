//
//  ListViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import Foundation

final class ListViewModel {
    
    @Published private(set) var gatheringList: [Gathering] = []
    private let buddyFaceUseCase: BuddyFaceInterface
    
    init() {
        self.buddyFaceUseCase = BuddyFaceUseCase()
        self.configure()
    }
    
    var count: Int {
        return gatheringList.count
    }
    
    subscript(index: Int) -> Gathering {
        return self.gatheringList.reversed()[index]
    }
    
    func didSearchFieldReturn(name: String?) {
        guard let name = name else { return }
        let gatheringList = self.buddyFaceUseCase.fetch(name: name) ?? []
        self.gatheringList = gatheringList
    }
    
    private func configure() {
//        self.insert()
        self.fetch()
        
    }
    
    func fetch() {
        guard let gatheringList = self.buddyFaceUseCase.fetch() else { return }
        self.gatheringList = gatheringList
    }
    
    let buddy1 = Buddy(id: UUID(), name: "정아", face: "FacePurple1")
    let buddy2 = Buddy(id: UUID(), name: "나정", face: "FacePink5")
    let buddy3 = Buddy(id: UUID(), name: "인우", face: "FaceBlue7")
    let buddy4 = Buddy(id: UUID(), name: "두연", face: "FaceGreen9")
    let buddy5 = Buddy(id: UUID(), name: "나현", face: "FaceRed2")
    let buddy6 = Buddy(id: UUID(), name: "은혜", face: "FaceYellow3")
    let buddy7 = Buddy(id: UUID(), name: "민성", face: "FaceBlue4")
    let buddy8 = Buddy(id: UUID(), name: "정현", face: "FaceGreen8")
    let buddy9 = Buddy(id: UUID(), name: "아현", face: "FacePink6")
    
    let date1 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1)) ?? Date()
    let date2 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 4)) ?? Date()
    let date3 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 6)) ?? Date()
    let date4 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 8)) ?? Date()
    let date5 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 10)) ?? Date()
    let date6 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 13)) ?? Date()
    let date7 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 15)) ?? Date()
    let date8 = Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 21)) ?? Date()
    let date9 = Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1)) ?? Date()
    let date10 = Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 13)) ?? Date()
    
    private func insert() {
        self.buddyFaceUseCase.insertBuddy(buddy: buddy1)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy2)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy3)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy4)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy5)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy6)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy7)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy8)
        self.buddyFaceUseCase.insertBuddy(buddy: buddy9)
        
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date1, place: nil, placeType: [0, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date2, place: nil, placeType: [2, 3, 4], buddy: [buddy1, buddy2, buddy3, buddy3, buddy4], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date3, place: nil, placeType: [4, 1, 2], buddy: [buddy5, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date4, place: nil, placeType: [5, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date5, place: nil, placeType: [6, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date6, place: nil, placeType: [7, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date7, place: nil, placeType: [8, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date8, place: nil, placeType: [2, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date9, place: nil, placeType: [0, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
        self.buddyFaceUseCase.insertGathering(gathering: Gathering(date: date10, place: nil, placeType: [0, 1, 2], buddy: [buddy1, buddy2, buddy3], memo: nil, picture: nil))
    }
    
}
