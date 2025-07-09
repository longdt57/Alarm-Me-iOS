//
//  AlarmUiState.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation

struct AlarmUiState: Equatable {
    var alarms: [AlarmModel]
    
    init(alarms: [AlarmModel] = []) {
        self.alarms = alarms
    }
}
