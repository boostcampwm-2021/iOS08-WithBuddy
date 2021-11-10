//
//  RegisterViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/03.
//

import Foundation
import Combine

enum RegisterError: LocalizedError {
    case noBuddy
    case noType
    
    var errorDescription: String? {
        switch self {
        case .noBuddy: return "최소 한명 이상의 버디를 추가해 주세요."
        case .noType: return "최소 한개 이상의 모임 목적을 추가해 주세요."
        }
    }
}

class RegisterViewModel {
    
    private var startDate: Date?
    private var endDate: Date?
    private var place: String?
    private var checkedPurposeList: [Purpose] {
        return self.purposeList.filter( { $0.check })
    }
    private(set) var registerDoneSignal = PassthroughSubject<Void, Never>()
    private(set) var registerFailSignal = PassthroughSubject<RegisterError, Never>()
    
    @Published private(set) var startDateString: String?
    @Published private(set) var endDateString: String?
    @Published private(set) var purposeList: [Purpose] = PlaceType.allCases.map({ Purpose(type: $0, check: false) })
    @Published private(set) var buddyList: [Buddy] = []
    @Published private(set) var memo: String?
    @Published private(set) var pictures: [URL] = []
    
    private var buddyUseCase = BuddyUseCase()
    private var gatheringUseCase = GatheringUseCase()
    
    func didStartDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.startDate = date
        self.startDateString = dateFormatter.string(from: date)
        
        if let endDate = self.endDate,
           endDate < date {
            self.endDate = self.startDate
            self.endDateString = self.startDateString
        }
    }
    
    func didEndDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        if let startDate = startDate,
           startDate > date {
            self.endDate = self.startDate
            self.endDateString = self.startDateString
            return
        }
        self.endDate = date
        self.endDateString = dateFormatter.string(from: date)
    }
    
    func didPlaceFinished(_ place: String) {
        self.place = place
    }
    
    func didTypeTouched(_ idx: Int) {
        self.purposeList[idx].check.toggle()
    }
    
    func didBuddySelected(_ buddy: Buddy) {
        self.buddyList.insert(buddy, at: 0)
        self.buddyUseCase.insertBuddy(buddy)
    }
    
    func didMemoFinished(_ memo: String) {
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
            self.registerFailSignal.send(RegisterError.noBuddy)
        } else {
            guard let startDate = startDate,
                  let endDate = endDate else {
                return
            }
            self.gatheringUseCase.insertGathering(Gathering(startDate: startDate, endDate: endDate, place: self.place, purpose: ["\(PlaceType.culture)", "\(PlaceType.study)", "\(PlaceType.etc)"], buddyList: self.buddyList, memo: self.memo, picture: self.pictures))
            self.registerDoneSignal.send()
        }
    }
}
