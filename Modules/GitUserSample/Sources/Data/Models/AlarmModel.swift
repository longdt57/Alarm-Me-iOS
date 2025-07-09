//
//  AlarmModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import RealmSwift

class AlarmModel: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var audio: AlarmAudioModel?
    @Persisted var createdAt: String?
    @Persisted var isEnabled: Bool
    @Persisted var label: String?
    @Persisted var repeatDays: List<Int>
    @Persisted var snoozeEnabled: Bool?
    @Persisted var timeOfDay: String?
    @Persisted var updatedAt: String?
    @Persisted var vibrate: Bool?
    
    // MARK: - Ignored Properties
    override static func ignoredProperties() -> [String] {
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
        return !repeatDays.isEmpty
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
