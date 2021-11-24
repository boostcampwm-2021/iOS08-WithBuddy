//
//  SettingViewModel.swift
//  WithBuddy
//
//  Created by 김두연 on 2021/11/24.
//

import Foundation

protocol SettingViewModelProtocol {
    
}

final class SettingViewModel {
    
    private let userUseCase: UserUseCase
    private let gatheringUseCase: GatheringUseCase
    
    init(
        userUseCase: UserUseCase,
        gatheringUseCase: GatheringUseCase
    ) {
        self.userUseCase = userUseCase
        self.gatheringUseCase = gatheringUseCase
    }
    
    func didGatheringResetTouched() {
    }
    
}
