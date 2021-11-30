//
//  GatheringDetailViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/16.
//

import Foundation
import Combine

final class GatheringDetailViewModel {
    
    @Published private(set) var gathering: Gathering?
    private(set) var goEditSignal = PassthroughSubject<Gathering, Never>()
    private let gatheringUseCase: GatheringUseCase
    private let purposeUseCase: PurposeUseCase
    
    init(
        gatheringUseCase: GatheringUseCase = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        purposeUseCase: PurposeUseCase = PurposeUseCase(coreDataManager: CoreDataManager.shared)
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.purposeUseCase = purposeUseCase
    }
    
    func viewDidAppear(with id: UUID) {
        self.gathering = self.gatheringUseCase.fetchGathering(id: id)
    }
    
    func didEditButtonTouched() {
        guard let gathering = self.gathering else { return }
        self.goEditSignal.send(gathering)
    }
    
    func engToKor(eng: String) -> String {
        return self.purposeUseCase.engToKor(eng: eng)
    }
    
}
