//
//  RegisterViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/03.
//

import Foundation

class RegisterViewModel {
    @Published private(set) var startDate: String? = nil
    @Published private(set) var endDate: String? = nil
    private var place: String? = nil
    @Published private(set) var typeSelectedList: [Bool] = Array(repeating: false, count: PlaceType.allCases.count)
    @Published private(set) var buddyList: [Buddy] = []
    @Published private(set) var memo: String? = nil
    @Published private(set) var pictures: [URL] = []
    
    func didStartDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.startDate = dateFormatter.string(from: date)
    }
    
    func didEndDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.endDate = dateFormatter.string(from: date)
    }
    
    func didPlaceFinished(_ place: String) {
        self.place = place
    }
    
    func didTypeTouched(_ idx: Int) {
        self.typeSelectedList[idx].toggle()
    }
    
    func didBuddySelected(_ buddy: Buddy) {
        self.buddyList.insert(buddy, at: 0)
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
}
