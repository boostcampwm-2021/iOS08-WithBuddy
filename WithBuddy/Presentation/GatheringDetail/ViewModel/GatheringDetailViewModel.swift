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
    private let gatheringUseCase: GatheringUseCaseProtocol
    private let purposeUseCase: PurposeUseCaseProtocol
    private var cancellable: Set<AnyCancellable> = []
    
    init(
        gatheringUseCase: GatheringUseCaseProtocol = GatheringUseCase(coreDataManager: CoreDataManager.shared),
        purposeUseCase: PurposeUseCaseProtocol = PurposeUseCase(coreDataManager: CoreDataManager.shared)
    ) {
        self.gatheringUseCase = gatheringUseCase
        self.purposeUseCase = purposeUseCase
    }
    
    func viewWillAppear(with id: UUID) {
        self.gatheringUseCase.fetchGathering(id: id)
            .sink { completion in
                //TODO: fetch error alert하기
                print(completion)
            } receiveValue: { [weak self] gathering in
                self?.gathering = gathering
            }
            .store(in: &self.cancellable)
    }
    
    func didEditButtonTouched() {
        guard let gathering = self.gathering else { return }
        self.goEditSignal.send(gathering)
    }
    
    func toKor(eng: String) -> String {
        return self.purposeUseCase.engToKor(eng: eng)
    }
    
}
