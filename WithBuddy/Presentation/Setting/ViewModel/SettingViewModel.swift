//
//  SettingViewModel.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/24.
//

import Foundation
import Combine

final class SettingViewModel {
    
    @Published private(set) var myBuddy: Buddy?
    
    private let userUseCase: UserUseCase
    private let gatheringUseCase: GatheringUseCaseProtocol
    private(set) var deleteSignal = PassthroughSubject<(String, String?), Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        userUseCase: UserUseCase = UserUseCase(),
        gatheringUseCase: GatheringUseCaseProtocol = GatheringUseCase(coreDataManager: CoreDataManager.shared)
    ) {
        self.userUseCase = userUseCase
        self.gatheringUseCase = gatheringUseCase
    }
    
    func didGatheringResetTouched() {
        self.gatheringUseCase.deleteAllGathering()
            .sink { [weak self] error in
                switch error {
                case .failure(let error):
                    self?.deleteSignal.send(("삭제 실패", error.errorDescription))
                case .finished:
                    return
                }
            } receiveValue: { [weak self] in
                self?.deleteSignal.send(("삭제 성공", "모임 삭제가 완료되었습니다."))
            }.store(in: &self.cancellable)
    }
    
    func didMyBuddyChanged(buddy: Buddy) {
        self.userUseCase.createUser(buddy: buddy)
    }
    
    func reloadMyBuddy() {
        self.myBuddy = self.userUseCase.fetchUser()
    }
    
}
