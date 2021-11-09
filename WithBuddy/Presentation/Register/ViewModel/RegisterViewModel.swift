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
<<<<<<< HEAD
    @Published private(set) var startDateString: String? = nil
    @Published private(set) var endDateString: String? = nil
    private var startDate: Date? = nil
    private var endDate: Date? = nil
<<<<<<< HEAD
    private var place: String? = nil
    @Published private(set) var purposeList: [Purpose] = PlaceType.allCases.map({ Purpose(type: $0, check: false) })
    private var checkedPurposeList: [Purpose] {
        return self.purposeList.filter( { $0.check })
    }
=======
=======
    private var startDate: Date?
    private var endDate: Date?
>>>>>>> 481e61b ((#56) refactor: register view Model에 passthroughsubject에 error 추가)
    private var place: String?
    private(set) var registerDoneSignal = PassthroughSubject<Void, Never>()
    private(set) var registerFailSignal = PassthroughSubject<RegisterError, Never>()
    
    @Published private(set) var startDateString: String?
    @Published private(set) var endDateString: String?
    @Published private(set) var typeSelectedList: [Bool] = Array(repeating: false, count: PlaceType.allCases.count)
>>>>>>> 008d7a9 ((#54) feat: combine을 활용해서 완료 버튼 눌렀을 시 navigation pop 되도록 구현)
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
            self.gatheringUseCase.insertGathering(Gathering(date: startDate, place: self.place, placeType: [], buddy: [], memo: self.memo, picture: self.pictures), buddy: self.buddyList)
            self.registerDoneSignal.send()
        }
    }
}
