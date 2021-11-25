//
//  GatheringDetailViewModel.swift
//  WithBuddy
//
//  Created by Inwoo Park on 2021/11/16.
//

import Foundation
import Combine

class GatheringDetailViewModel {
    
    @Published private(set) var gathering: Gathering?
    private(set) var goEditSignal = PassthroughSubject<Gathering, Never>()
    private let purposeUseCase = PurposeUseCase(coreDataManager: CoreDataManager.shared)
    
    func didGatheringChanged(to gathering: Gathering) {
        self.gathering = gathering
    }
    
    func didEditButtonTouched() {
        guard let gathering = self.gathering else { return }
        self.goEditSignal.send(gathering)
    }
    
    func engToKor(eng: String) -> String {
        return self.purposeUseCase.engToKor(eng: eng)
    }
    
}
