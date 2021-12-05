//
//  CalendarDetailViewModel.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/09.
//

import Foundation
import Combine

final class CalendarDetailViewModel {
    
    @Published private(set) var dayLabel: String = String()
    @Published private(set) var gatheringList: [Gathering] = []
    
    private(set) var deleteSuccessSingal = PassthroughSubject<Gathering, Never>()
    private let gatheringUseCase: GatheringUseCaseProtocol
    private let calendarUseCase: CalendarUseCase
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        gatheringUseCase: GatheringUseCaseProtocol = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        calendarUseCase: CalendarUseCase = CalendarUseCase()
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.calendarUseCase = calendarUseCase
    }
    
    var count: Int {
        return gatheringList.count
    }
    
    subscript(index: Int) -> Gathering {
        return self.gatheringList[index]
    }
    
    func viewDidLoad(with date: Date) {
        self.dayLabel = self.calendarUseCase.convertToString(day: date)
        self.gatheringUseCase.fetchGathering(day: date)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    //TODO: gathering fetch error alert해주기
                    print(error.errorDescription)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] gatheringList in
                self?.gatheringList = gatheringList
            }
            .store(in: &self.cancellable)
    }
    
    func didDeleteButtonTouched(index: Int) {
        self.gatheringUseCase.deleteGathering(gatheringList[index].id)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    //TODO: gathering 삭제 오류 alert 해주기
                    print(error.errorDescription)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] in
                guard let gathering = self?.gatheringList.remove(at: index) else { return }
                self?.deleteSuccessSingal.send(gathering)
            }
            .store(in: &self.cancellable)
    }

}
