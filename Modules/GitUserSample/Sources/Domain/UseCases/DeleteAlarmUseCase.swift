//
//  DeleteAlarmUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import Combine

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
    
    func invoke(alarm: AlarmModel) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let _ = try await self.alarmRepository.deleteAlarm(id: alarm.id)
                    self.alarmClockHelper.cancelAlarm(alarm)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
