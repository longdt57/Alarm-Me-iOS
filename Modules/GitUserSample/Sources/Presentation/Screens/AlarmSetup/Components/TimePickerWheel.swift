//
//  TimePickerWheel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

import SwiftUI

struct TimePickerWheel: View {
    @Binding private var state: TimePickerState
    private let onTimeSelected: (TimePickerState) -> Void
    
    private let hours = Array(1...12)
    private let minutes = Array(0...59)
    private let periods = [TimePickerState.AM, TimePickerState.PM]
    
    init(state: Binding<TimePickerState>, onTimeSelected: @escaping (TimePickerState) -> Void) {
        self._state = state
        self.onTimeSelected = onTimeSelected
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Picker("Hour", selection: $state.hour) {
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
            
            Picker("Minute", selection: $state.minute) {
                ForEach(minutes, id: \.self) { minute in
                    Text(String(format: "%02d", minute)).tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
            
            Picker("Period", selection: $state.period) {
                ForEach(periods, id: \.self) { period in
                    Text(period).tag(period)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
        .onChange(of: state) { newValue in
            onTimeSelected(newValue)
        }
    }
}
