//
//  UpdateAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

final class UpdateAlarmUseCase {
    private let alarmRepository: AlarmRepository
    private let alarmClockHelper: AlarmClockHelper
    
    init(
        alarmRepository: AlarmRepository,
        alarmClockHelper: AlarmClockHelper
    ) {
        self.alarmRepository = alarmRepository
        self.alarmClockHelper = alarmClockHelper
    }
    
    func execute(_ newAlarm: AlarmModel) async throws -> AlarmModel {
        let result = try await alarmRepository.updateAlarm(newAlarm)
        alarmClockHelper.cancelAlarm(newAlarm)
        if newAlarm.isEnabled {
            alarmClockHelper.setupAlarmClock(newAlarm)
        }
        return result
    }
}
