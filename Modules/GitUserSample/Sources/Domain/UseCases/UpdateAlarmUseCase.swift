//
//  UpdateAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Combine
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
    
    func invoke(_ newAlarm: AlarmModel) -> AnyPublisher<AlarmModel, Error> {
        return Future<AlarmModel, Error> { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let result = try await self.alarmRepository.updateAlarm(newAlarm)
                    self.alarmClockHelper.cancelAlarm(newAlarm)
                    if newAlarm.isEnabled {
                        self.alarmClockHelper.setupAlarmClock(newAlarm)
                    }
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
