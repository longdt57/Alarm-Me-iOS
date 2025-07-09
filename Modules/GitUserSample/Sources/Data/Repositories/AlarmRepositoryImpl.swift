//
//  AlarmRepositoryImpl.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Combine
import Data

import Foundation
import Combine
import RealmSwift

final class AlarmRepositoryImpl: AlarmRepository {
    private let alarmLocalSource: AlarmLocalSource
    private let alarmAudioLocalSource: AlarmAudioLocalSource
    
    init(
        alarmLocalSource: AlarmLocalSource = AlarmLocalSourceImpl(),
        alarmAudioLocalSource: AlarmAudioLocalSource = AlarmAudioLocalSourceImpl()
    ) {
        self.alarmLocalSource = alarmLocalSource
        self.alarmAudioLocalSource = alarmAudioLocalSource
    }
    
    // MARK: - Alarm
    
    func observeAlarms() -> AnyPublisher<[AlarmModel], Never> {
        alarmLocalSource.observeAlarms()
            .map { Array($0) }
            .replaceError(with: []) // suppress any Realm error
            .eraseToAnyPublisher()
    }
    
    func getEnabledAlarms() async throws -> [AlarmModel] {
        alarmLocalSource.getEnabledAlarms()
    }
    
    func createAlarm(_ alarm: AlarmModel) async throws -> AlarmModel {
        try alarmLocalSource.upsert(alarm)
        return alarm
    }
    
    func updateAlarm(_ alarm: AlarmModel) async throws -> AlarmModel {
        try alarmLocalSource.upsert(alarm)
        return alarm
    }
    
    func enableAlarm(id: Int, enable: Bool) async throws {
        try alarmLocalSource.setEnable(id, enable)
    }
    
    func deleteAlarm(id: Int) async throws {
        try alarmLocalSource.deleteById(id)
    }
    
    func getAlarmById(id: Int) async throws -> AlarmModel? {
        alarmLocalSource.getAlarmById(id)
    }
    
    // MARK: - Alarm Audio
    
    func fetchAlarmAudio() async throws -> [AlarmAudioModel] {
        let audios = Self.sampleAudios
        try alarmAudioLocalSource.clearAll()
        try alarmAudioLocalSource.upsertAll(audios)
        return audios
    }
    
    func observeAlarmAudio() -> AnyPublisher<[AlarmAudioModel], Never> {
        alarmAudioLocalSource.observeAlarmAudios()
            .collectionPublisher
            .map { Array($0) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    // MARK: - Sample Audios
    
    static let sampleAudios: [AlarmAudioModel] = [
        AlarmAudioModel(id: 1, durationS: 10,
                        fileUrl: "https://archive.org/download/alarm-morning-flower/Alarm_Morning_flower.ogg",
                        title: "Morning Flower (Samsung)"),
        AlarmAudioModel(id: 3, durationS: nil,
                        fileUrl: "https://archive.org/download/morning-alarm-ringtone/Morning%20Alarm%20Ringtone.mp3",
                        title: "Morning Alarm Ringtone"),
        AlarmAudioModel(id: 5, durationS: 14,
                        fileUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Alarmclock-mechanical.ogg",
                        title: "Mechanical Alarm Clock"),
        AlarmAudioModel(id: 6, durationS: 8,
                        fileUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/NFPA_Fire_Alarm.ogg",
                        title: "Fire Alarm Tone (NFPA Standard)")
    ]
}
