//
//  AlarmRepository.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Combine

protocol AlarmRepository {
    func observeAlarms() -> AnyPublisher<[AlarmModel], Never>
    func getEnabledAlarms() async throws -> [AlarmModel]
    func createAlarm(_ alarm: AlarmModel) async throws -> AlarmModel
    func updateAlarm(_ alarm: AlarmModel) async throws -> AlarmModel
    func enableAlarm(id: Int, enable: Bool) async throws
    func deleteAlarm(id: Int) async throws
    func getAlarmById(id: Int) async throws -> AlarmModel?
    
    func fetchAlarmAudio() async throws -> [AlarmAudioModel]
    func observeAlarmAudio() -> AnyPublisher<[AlarmAudioModel], Never>
}
