//
//  RegisterViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/03.
//

import Foundation

class RegisterViewModel {
    @Published private(set) var date: String? = nil
    private var place: String? = nil
    @Published private(set) var type: Set<PlaceType> = []
    @Published private(set) var buddyList: Set<Buddy> = []
    @Published private(set) var memo: String? = nil
    @Published private(set) var pictures: [URL] = []
    
    func didDatePicked(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.date = dateFormatter.string(from: date)
    }
    
    func didPlaceFinished(_ place: String) {
        self.place = place
    }
    
    func didTypeTouched(_ type: PlaceType) {
    }
    
    func didBuddySelected(_ buddy: Buddy) {
    }
    
    func didMemoFinished(_ memo: String) {
        self.memo = memo
    }
    
    func didPicturePicked(_ picture: URL) {
        self.pictures.append(picture)
    }
}
