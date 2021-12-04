//
//  CalendarViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation
import Combine

protocol CalendarViewModlInput {
    
}

protocol CalendarViewModelOutput {
    var facePublisher: Published<String?>.Publisher { get }
    var didDaysReloadSignal: PassthroughSubject<Void, Never> { get }
}

protocol CalendarViewModelProtocol: CalendarViewModlInput & CalendarViewModelOutput {}

final class CalendarViewModel {
    
    @Published private(set) var myFace: String?
    @Published private(set) var headerComment: String?
    
    private let calendarUseCase: CalendarUseCase
    private let gatheringUseCase: GatheringUseCaseProtocol
    private let userUseCase: UserUseCase
    private var calendarMonth: Date
    private var currentDate: Date
    private var thisMonthGathrtingList = [Gathering]()
    
    private(set) var isSameMonth: Int?
    private(set) var totalDays = [Int]()
    private(set) var totalFaces = [String]()
    private(set) var totalGathering = [Int]()
    private(set) var monthSubject = PassthroughSubject<String, Never>()
    private(set) var didDaysReloadSignal = PassthroughSubject<Void, Never>()
    private(set) var didGatheringReloadSignal = PassthroughSubject<Void, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        gatheringUseCase: GatheringUseCaseProtocol = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        calendarUseCase: CalendarUseCase = CalendarUseCase(),
        userUseCase: UserUseCase = UserUseCase()
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.calendarUseCase = calendarUseCase
        self.userUseCase = userUseCase
        self.currentDate = Date()
        self.calendarMonth = self.calendarUseCase.firstTimeOfDay(baseDate: Date())
    }
    
    func viewDidAppear() {
        self.fetchBuddyFace()
        self.currentDate = Date()
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
        self.reloadTotalGathering()
        self.loadHeaderComment()
    }
    
    private func loadHeaderComment() {
        self.gatheringUseCase.fetchGathering(oneWeekFrom: currentDate)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.headerComment = error.errorDescription
                case .finished:
                    return
                }
            } receiveValue: { [weak self] gatheringList in
                guard let gatheringExist = self?.countGathering(gatheringList) else { return }
                self?.headerComment = self?.selectHeaderComment(gatheringExist: gatheringExist)
            }
            .store(in: &self.cancellable)
    }
    
    private func selectHeaderComment(gatheringExist: [Int]) -> String {
        if gatheringExist[Int.zero] > Int.zero {
            return HeaderComments.gatheringToday.rawValue
        }
        var nextGatheringDay = Int.numOfWeek
        for (index, count) in gatheringExist.enumerated() where count > Int.zero {
            nextGatheringDay = index
            break
        }
        
        if nextGatheringDay > 1 {
            return "\(nextGatheringDay) \(HeaderComments.noGathering.rawValue)"
        }
        
        var continuousDay = 1
        for index in 2..<Int.numOfWeek {
            if gatheringExist[index] > Int.zero {
                continuousDay = index
            } else { break }
        }
        
        switch continuousDay {
        case 1: return "\(HeaderComments.gatheringTomorrow.rawValue)"
        default: return "\(continuousDay) \(HeaderComments.fullGathering.rawValue)"
        }
    }
    
    private func countGathering(_ gatheringList: [Gathering]) -> [Int] {
        var result = [Int](repeating: 0, count: Int.numOfWeek)
        var day = self.currentDate
        for idx in Int.zero..<Int.numOfWeek {
            result[idx] = gatheringList.filter{ self.calendarUseCase.isSameDay(date1: $0.date, date2: day) }.count
            day = self.calendarUseCase.nextDay(baseDate: day)
        }
        return result
    }
    
    func didMonthButtonTouched(number: Int) {
        guard let month = number == Int.zero ? Date() : self.calendarUseCase.changeMonth(self.calendarMonth, by: number) else { return }
        self.calendarMonth = month
        self.sendMonthSubject()
        self.reloadDays()
        self.reloadFaces()
        self.reloadTotalGathering()
    }
    
    func findDate(index: Int) -> Date {
        return self.calendarUseCase.makeDay(month: self.calendarMonth, day: self.totalDays[index])
    }
    
    private func fetchBuddyFace() {
        guard let buddy = self.userUseCase.fetchUser() else { return }
        self.myFace = buddy.face
    }
    
    private func sendMonthSubject() {
        self.monthSubject.send(self.calendarUseCase.convertToString(month: self.calendarMonth))
    }
    
    private func reloadDays() {
        let numOfDaysInMonth = calendarUseCase.numOfDaysInMonth(baseDate: self.calendarMonth)
        let firstDayIndex = calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.totalDays = Array(repeating: Int.zero, count: .maxDayOfMonth)
        
        for index in Int.zero..<numOfDaysInMonth {
            self.totalDays[index+firstDayIndex] = index + 1
        }
        
        self.isSameMonth = self.calendarUseCase.isSameDay(date1: self.calendarMonth, date2: self.currentDate) ? firstDayIndex + self.calendarUseCase.day(baseDate: self.currentDate) - 1 : nil
        
        self.didDaysReloadSignal.send()
    }
    
    func reloadFaces() {
        self.gatheringUseCase.fetchGathering(month: self.calendarMonth)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    //TODO: error alert 처리하기
                    print(error.errorDescription)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] gatheringList in
                self?.configureBuddyFace(from: gatheringList)
                self?.didGatheringReloadSignal.send()
            }
            .store(in: &self.cancellable)
    }
    
    private func reloadTotalGathering() {
        self.totalGathering = Array(repeating: Int.zero, count: Int.maxDayOfMonth)
        
        let firstDayIndex = self.calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        self.thisMonthGathrtingList.forEach {
            let day = self.calendarUseCase.day(baseDate: $0.date)
            self.totalGathering[firstDayIndex + day - 1] += 1
        }
    }
    
    private func configureBuddyFace(from gatheringList: [Gathering]) {
        self.totalFaces = Array(repeating: String(), count: .maxDayOfMonth)
        let firstDayIndex = self.calendarUseCase.findFirstDayIndex(of: self.calendarMonth)
        
        gatheringList.forEach {
            let day = self.calendarUseCase.day(baseDate: $0.date)
            if let face = $0.buddyList.first?.face {
                self.totalFaces[firstDayIndex + day - 1] = face
            }
        }
    }
    
}
