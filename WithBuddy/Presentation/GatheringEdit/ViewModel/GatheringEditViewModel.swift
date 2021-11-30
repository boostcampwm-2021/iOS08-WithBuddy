//
//  GatheringEditViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/16.
//

import Foundation
import Combine

final class GatheringEditViewModel {
    
    var gatheringId: UUID?
    private var date: Date?
    private var checkedPurposeList: [CheckableInfo] {
        return self.purposeList.filter( { $0.check })
    }
    
    private(set) var addBuddySignal = PassthroughSubject<[Buddy], Never>()
    private(set) var editDoneSignal = PassthroughSubject<Gathering, Never>()
    private(set) var editFailSignal = PassthroughSubject<RegisterError, Never>()
    
    @Published private(set) var place: String?
    @Published private(set) var dateString: String?
    @Published private(set) var purposeList: [CheckableInfo] = []
    @Published private(set) var buddyList: [Buddy] = []
    @Published private(set) var memo: String?
    @Published private(set) var pictures: [URL] = []
    
    private var buddyUseCase = BuddyUseCase(coreDataManager: CoreDataManager.shared)
    private var gatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    private var purposeUseCase = PurposeUseCase(coreDataManager: CoreDataManager.shared)
    
    init() {
        self.configure()
    }
    
    func didDatePicked(_ date: Date) {
        self.date = date
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
        if self.buddyList.isEmpty {
            self.editFailSignal.send(RegisterError.noBuddy)
        } else if self.checkedPurposeList.isEmpty {
            self.editFailSignal.send(RegisterError.noType)
        } else {
            guard let gatheringId = gatheringId,
                  let date = date else {
                      return
                  }
            let gathering = Gathering(
                id: gatheringId,
                date: date,
                place: self.place,
                purpose: self.checkedPurposeList.map{ $0.engDescription },
                buddyList: self.buddyList,
                memo: self.memo,
                picture: self.pictures
            )
            
            self.gatheringUseCase.updateGathering(gathering)
            self.editDoneSignal.send(gathering)
        }
    }
    
    func didAddBuddyTouched() {
        self.addBuddySignal.send(self.buddyList)
    }
    
    func didDeleteButtonTouched() {
        guard let id = self.gatheringId else { return }
        self.gatheringUseCase.deleteGathering(id)
    }
    
    private func configure() {
        self.purposeList = PurposeCategory.allCases.map({ CheckableInfo(engDescription: "\($0)", korDescription: self.purposeUseCase.engToKor(eng: "\($0)"), check: false) })
    }
    
}
