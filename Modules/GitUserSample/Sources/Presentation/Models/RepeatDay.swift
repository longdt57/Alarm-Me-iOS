//
//  RepeatDay.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

enum RepeatDay: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    static func fromValue(_ value: Int) -> RepeatDay? {
        return RepeatDay(rawValue: value)
    }
    
    static func weekdayValues() -> [Int] {
        return RepeatDay.allCases
            .filter { $0.rawValue >= RepeatDay.monday.rawValue && $0.rawValue <= RepeatDay.friday.rawValue }
            .map { $0.rawValue }
    }
    
    static func weekendValues() -> [Int] {
        return [RepeatDay.saturday.rawValue, RepeatDay.sunday.rawValue]
    }
}
