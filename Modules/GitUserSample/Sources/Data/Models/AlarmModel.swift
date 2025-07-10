//
//  AlarmModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import RealmSwift

public class AlarmModel: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var audio: AlarmAudioModel?
    @Persisted var createdAt: String?
    @Persisted var isEnabled: Bool
    @Persisted var label: String?
    @Persisted var repeatDays: String?
    @Persisted var snoozeEnabled: Bool?
    @Persisted var timeOfDay: String?
    @Persisted var updatedAt: String?
    @Persisted var vibrate: Bool?
    
    convenience init(
        id: Int,
        audio: AlarmAudioModel? = nil,
        createdAt: String? = nil,
        isEnabled: Bool,
        label: String? = nil,
        repeatDays: String? = nil,
        snoozeEnabled: Bool? = nil,
        timeOfDay: String? = nil,
        updatedAt: String? = nil,
        vibrate: Bool? = nil
    ) {
        self.init()
        self.id = id
        self.audio = audio
        self.createdAt = createdAt
        self.isEnabled = isEnabled
        self.label = label
        self.repeatDays = repeatDays
        self.snoozeEnabled = snoozeEnabled
        self.timeOfDay = timeOfDay
        self.updatedAt = updatedAt
        self.vibrate = vibrate
    }

    
    // MARK: - Ignored Properties
    public override static func ignoredProperties() -> [String] {
        return ["timeInMinutes", "soundUri", "displayTime"]
    }
    
    // MARK: - Computed Properties
    var timeInMinutes: Int {
        guard let timeOfDay = timeOfDay else { return 0 }
        return DateTimeUtil.toTimeInMinutes(timeOfDay) ?? 0
    }
    
    var soundUri: String {
        return audio?.fileUrl ?? ""
    }
    
    var displayTime: String {
        return DateTimeUtil.convertToAlarmDisplayFormat(timeOfDay ?? "")
    }
    
    func isRecurring() -> Bool {
        return !repeatDays.isNilOrBlank()
    }
    
    func isToday() -> Bool {
        return !isRecurring() && timeInMinutes > DateTimeUtil.getCurrentDayMinutes()
    }
    
    func isTomorrow() -> Bool {
        return !isRecurring() && timeInMinutes <= DateTimeUtil.getCurrentDayMinutes()
    }
    
    // Codable keys (optional)
    private enum CodingKeys: String, CodingKey {
        case id, audio, createdAt = "created_at", isEnabled = "is_enabled", label,
             repeatDays = "repeat_days", snoozeEnabled = "snooze_enabled",
             timeOfDay = "time_of_day", updatedAt = "updated_at", vibrate
    }
}
