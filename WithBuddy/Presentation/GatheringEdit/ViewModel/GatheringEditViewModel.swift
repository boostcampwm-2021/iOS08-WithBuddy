//
//  GatheringEditViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/16.
//

import Foundation
import Combine

class GatheringEditViewModel {
    
    private var date: Date?
    private var place: String?
    private var checkedPurposeList: [Purpose] {
        return self.purposeList.filter( { $0.check })
    }
    private(set) var addBuddySignal = PassthroughSubject<[Buddy], Never>()
    private(set) var editDoneSignal = PassthroughSubject<Void, Never>()
    private(set) var editFailSignal = PassthroughSubject<RegisterError, Never>()
    
    @Published private(set) var dateString: String?
    @Published private(set) var purposeList: [Purpose] = PlaceType.allCases.map({ Purpose(type: $0, check: false) })
    @Published private(set) var buddyList: [Buddy] = []
    @Published private(set) var memo: String?
    @Published private(set) var pictures: [URL] = []
    
    private var buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
    private var gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    
    func didDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.date = Calendar.current.startOfDay(for: date)
        self.dateString = dateFormatter.string(from: date)
    }
    
    func didPlaceChanged(_ place: String) {
        self.place = place
    }
    
    func didPurposeTouched(_ idx: Int) {
        self.purposeList[idx].check.toggle()
    }
    
    func didBuddyAdded(_ buddy: Buddy) {
        self.buddyList.insert(buddy, at: 0)
    }
    
    func didBuddyUpdated(_ buddyList: [Buddy]) {
        self.buddyList = buddyList
    }
    
    func didMemoChanged(_ memo: String) {
        self.memo = memo
    }
    
    func didPicturePicked(_ picture: URL) {
        self.pictures.insert(picture, at: 0)
    }
    
    func didPictureDeleteTouched(in idx: Int) {
        if idx < self.pictures.count {
            self.pictures.remove(at: idx)
        }
    }
    
    func didBuddyDeleteTouched(in idx: Int) {
        if idx < self.buddyList.count {
            self.buddyList.remove(at: idx)
        }
    }
    
    func didDoneTouched() {
        // 여기서 편집된 내용을 저장하는 처리를 합니다. 
    }
    
    func didAddBuddyTouched() {
        self.addBuddySignal.send(self.buddyList)
    }
    
}
