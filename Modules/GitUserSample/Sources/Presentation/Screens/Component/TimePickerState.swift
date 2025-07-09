//
//  TimePickerState.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

struct TimePickerState: Equatable {
    var hour: Int = 0
    var minute: Int = 0
    var period: String = AM
    
    static let AM = "AM"
    static let PM = "PM"
    
    static func parseTimeToPickerState(_ time: String) -> TimePickerState {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: time) else {
            return TimePickerState(hour: 12, minute: 0, period: AM) // fallback
        }
        
        let calendar = Calendar.current
        let hour24 = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let period = hour24 < 12 ? AM : PM
        
        let hour12: Int
        switch hour24 {
            case 0:
                hour12 = 12
            case 13...23:
                hour12 = hour24 - 12
            default:
                hour12 = hour24
        }
        
        return TimePickerState(hour: hour12, minute: minute, period: period)
    }
}
