//
//  CreateAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

import Foundation
import Combine

final class CreateAlarmUseCase {
    private let alarmRepository: AlarmRepository
    private let alarmClockHelper: AlarmClockHelper
    
    init(alarmRepository: AlarmRepository, alarmClockHelper: AlarmClockHelper) {
        self.alarmRepository = alarmRepository
        self.alarmClockHelper = alarmClockHelper
    }
    
    func invoke(alarm: AlarmModel) -> AnyPublisher<AlarmModel, Error> {
        Future<AlarmModel, Error> { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let created = try await self.alarmRepository.createAlarm(alarm)
                    self.alarmClockHelper.setupAlarmClock(created)
                    promise(.success(created))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
