//
//  DatetimeUtil.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

enum DateTimeUtil {
    static let hhmmss = "HH:mm:ss"
    static let hmmA = "h:mm a"
    static let hhmm = "HH:mm"
    
    /// Convert "HH:mm:ss" -> total minutes of the day
    static func toTimeInMinutes(_ timeOfDay: String) -> Int? {
        let parts = timeOfDay.split(separator: ":").compactMap { Int($0) }
        guard parts.count >= 2 else { return nil }
        let hours = parts[0]
        let minutes = parts[1]
        return hours * 60 + minutes
    }
    
    /// Current time in minutes of the day
    static func getCurrentDayMinutes() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        return hour * 60 + minute
    }
    
    /// Return current time as "HH:mm:ss"
    static func getCurrentAlarmTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = hhmmss
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }
    
    /// Convert "HH:mm:ss" to "h:mm a" (e.g. "22:00:00" -> "10:00 PM")
    static func convertToAlarmDisplayFormat(_ time: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = hhmmss
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = hmmA
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: time) {
            return outputFormatter.string(from: date)
        } else {
            return time // fallback if parsing fails
        }
    }
    
    /// Convert hour, minute, and AM/PM to "HH:mm:ss"
    static func convertToAlarmSaveTime(hour: Int, minute: Int, period: String) -> String {
        let inputString = String(format: "%d:%02d %@", hour, minute, period.uppercased())
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = hmmA
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = hhmmss
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: inputString) {
            return outputFormatter.string(from: date)
        } else {
            return "00:00:00"
        }
    }
}
