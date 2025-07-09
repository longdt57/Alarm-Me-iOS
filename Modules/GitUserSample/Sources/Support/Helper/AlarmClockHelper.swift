//
//  AlarmClockHelper.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

protocol AlarmClockHelper {
    func setupAlarmClock(_ alarm: AlarmModel)
    func cancelAlarm(_ alarm: AlarmModel)
}

final class AlarmClockHelperImpl: AlarmClockHelper {
    func cancelAlarm(_ alarm: AlarmModel) {
        
    }
    
    func setupAlarmClock(_ alarm: AlarmModel) {
    }
}
