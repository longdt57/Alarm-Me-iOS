//
//  AlarmSetupUiState.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

struct AlarmSetupUiState: Equatable {
    var audio: AlarmAudioModel? = nil
    var id: Int = 0
    var isEnabled: Bool = true
    var label: String = ""
    var repeatDays: [Int] = []
    var snoozeEnabled: Bool = true
    var timeOfDay: String
    var initialTimePickerState: TimePickerState
    var audioList: [AlarmAudioModel] = []
    
    var isNewAlarm: Bool {
        id <= 0
    }
    
    init(
        audio: AlarmAudioModel? = nil,
        id: Int = 0,
        isEnabled: Bool = true,
        label: String = "",
        repeatDays: [Int] = [],
        snoozeEnabled: Bool = true,
        timeOfDay: String = DateTimeUtil.getCurrentAlarmTime(),
        initialTimePickerState: TimePickerState? = nil,
        audioList: [AlarmAudioModel] = []
    ) {
        self.audio = audio
        self.id = id
        self.isEnabled = isEnabled
        self.label = label
        self.repeatDays = repeatDays
        self.snoozeEnabled = snoozeEnabled
        self.timeOfDay = timeOfDay
        self.initialTimePickerState = initialTimePickerState ?? TimePickerState.parseTimeToPickerState(timeOfDay)
        self.audioList = audioList
    }
}
