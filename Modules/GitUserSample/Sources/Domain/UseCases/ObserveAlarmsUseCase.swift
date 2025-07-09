//
//  ObserveAlarmsUseCase.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import Combine

final class ObserveAlarmsUseCase {
    private let alarmRepository: AlarmRepository
    
    init(alarmRepository: AlarmRepository) {
        self.alarmRepository = alarmRepository
    }
    
    func execute() -> AnyPublisher<[AlarmModel], Never> {
        alarmRepository.observeAlarms()
    }
}
