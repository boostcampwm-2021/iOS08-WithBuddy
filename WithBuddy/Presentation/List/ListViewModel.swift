//
//  ListViewModel.swift
//  WithBuddy
//
//  Created by 박정아 on 2021/11/04.
//

import Foundation

final class ListViewModel {
    
    @Published private(set) var gatheringList: [TmpGatheringList] = []
    
    init() {
        self.configure()
    }
    
    var count: Int {
        return gatheringList.count
    }
    
    subscript(index: Int) -> TmpGatheringList {
        return self.gatheringList.reversed()[index]
    }
    
    private func configure() {
        let useCase: BuddyFaceInterface = BuddyFaceUseCase()
        let faceList = useCase.faceList(color: FaceColor.purple)
        let buddy1 = TmpBuddy(name: "정아", face: faceList[0])
        let buddy2 = TmpBuddy(name: "나정", face: faceList[3])
        let buddy3 = TmpBuddy(name: "인우", face: faceList[6])
        let buddy4 = TmpBuddy(name: "두연", face: faceList[8])
        let type1 = "FaceGreen"
        let type2 = "FacePurple"
        let type3 = "FaceRed"
        let type4 = "FaceBlue"
        let type5 = "FaceYellow"
        let type6 = "FacePink"
        let type7 = "FaceGreen"
        let type8 = "FacePurple"
        self.gatheringList = [TmpGatheringList(date: "2021.10.24", buddyList: [buddy1, buddy2, buddy3, buddy4], type: [type1, type2]),
                              TmpGatheringList(date: "2021.10.25", buddyList: [buddy4, buddy2, buddy3], type: [type1, type2, type3]),
                              TmpGatheringList(date: "2021.10.26", buddyList: [buddy4, buddy2, buddy3, buddy4, buddy1, buddy2, buddy3, buddy4], type: [type2, type5, type6, type7]),
                              TmpGatheringList(date: "2021.10.27", buddyList: [buddy1, buddy3, buddy4], type: [type3, type2]),
                              TmpGatheringList(date: "2021.10.28", buddyList: [buddy2, buddy2, buddy3, buddy4], type: [type1, type2]),
                              TmpGatheringList(date: "2021.10.29", buddyList: [buddy2, buddy3, buddy4], type: [type4, type6]),
                              TmpGatheringList(date: "2021.10.30", buddyList: [buddy3, buddy2, buddy4], type: [type7, type2]),
                              TmpGatheringList(date: "2021.10.31", buddyList: [buddy3, buddy2, buddy3], type: [type1]),
                              TmpGatheringList(date: "2021.11.01", buddyList: [buddy1, buddy3, buddy4], type: [type7, type8])]
    }
    
}

struct TmpGatheringList: Hashable {
    
    let id = UUID()
    private(set) var date: String
    private(set) var buddyList: [TmpBuddy]
    private(set) var type: [String]
    
    init(date: String, buddyList: [TmpBuddy], type: [String]) {
        self.date = date
        self.buddyList = buddyList
        self.type = type
    }
    
}

struct TmpBuddy: Hashable {
    
    private var name: String
    private(set) var face: String
    
    init(name: String, face: String) {
        self.name = name
        self.face = face
    }
    
}
