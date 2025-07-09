//
//  GetAlarmByIdUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

final class GetAlarmByIdUseCase {
    private let alarmRepository: AlarmRepository
    
    init(alarmRepository: AlarmRepository) {
        self.alarmRepository = alarmRepository
    }
    
    func invoke(id: Int) async throws -> AlarmModel? {
        try await alarmRepository.getAlarmById(id: id)
    }
}
