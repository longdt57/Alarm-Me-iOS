//
//  AlarmUtil.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

func getAlarmRepeatDisplayText(
    _ repeatDays: [Int],
    defaultText: String = ""
) -> String {
    let sortedRepeatDays = repeatDays.sorted()
    
    if sortedRepeatDays.isEmpty {
        return defaultText
    }
    
    if sortedRepeatDays == RepeatDay.allCases.map(\.rawValue) {
        return R.string.localizable.everyday()
    }
    
    if sortedRepeatDays == RepeatDay.weekdayValues() {
        return R.string.localizable.every_weekday()
    }
    
    if sortedRepeatDays == RepeatDay.weekendValues() {
        return R.string.localizable.every_weekend()
    }
    
    // Day resources in correct order: Mon (0) to Sun (6)
    let dayResources = [
        R.string.localizable.mon(),
        R.string.localizable.tue(),
        R.string.localizable.wed(),
        R.string.localizable.thu(),
        R.string.localizable.fri(),
        R.string.localizable.sat(),
        R.string.localizable.sun()
    ]
    
    // Mimic Android: (day + 5) % 7 → reorders [1(Sun)..7(Sat)] to [Mon..Sun]
    let mapped = sortedRepeatDays.map { ($0 + 5) % 7 }.sorted()
    
    return mapped.map { dayResources[$0 % 7] }.joined(separator: ", ")
}
