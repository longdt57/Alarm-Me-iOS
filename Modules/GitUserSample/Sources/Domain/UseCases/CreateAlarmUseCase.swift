//
//  CreateAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

final class CreateAlarmUseCase {
    private let alarmRepository: AlarmRepository
    private let alarmClockHelper: AlarmClockHelper
    
    init(alarmRepository: AlarmRepository, alarmClockHelper: AlarmClockHelper) {
        self.alarmRepository = alarmRepository
        self.alarmClockHelper = alarmClockHelper
    }
    
    func execute(alarm: AlarmModel) async throws -> AlarmModel {
        let created = try await self.alarmRepository.createAlarm(alarm)
        self.alarmClockHelper.setupAlarmClock(created)
        return created
    }
}
