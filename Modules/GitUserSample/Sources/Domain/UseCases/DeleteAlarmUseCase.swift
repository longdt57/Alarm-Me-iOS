//
//  DeleteAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

final class DeleteAlarmUseCase {
    private let alarmRepository: AlarmRepository
    private let alarmClockHelper: AlarmClockHelper
    
    init(
        alarmRepository: AlarmRepository,
        alarmClockHelper: AlarmClockHelper
    ) {
        self.alarmRepository = alarmRepository
        self.alarmClockHelper = alarmClockHelper
    }
    
    func execute(alarmId: Int) async throws{
        guard let alarm = try await alarmRepository.getAlarmById(id: alarmId) else { return }
        alarmClockHelper.cancelAlarm(alarm)
    }
}
