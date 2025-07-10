//
//  AlarmSetupScreenContent.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

struct AlarmSetupScreenContent: View {
    @State var uiState = AlarmSetupUiState()
    
    var timePickerBinding: Binding<TimePickerState> {
        Binding<TimePickerState>(
            get: { uiState.initialTimePickerState },
            set: { newValue in
                uiState.initialTimePickerState = newValue
                uiState.timeOfDay = DateTimeUtil.convertToAlarmSaveTime(
                    hour: newValue.hour, minute: newValue.minute, period: newValue.period
                )
            }
        )
    }

    let onSnoozeChange: (Bool) -> Void
    let onRepeatClick: () -> Void
    let onAudioClick: () -> Void
    let onLabelChange: (String) -> Void
    let onTimeChange: (TimePickerState) -> Void
    let onDeleteClick: () -> Void
    
    private let itemHeight: CGFloat = 40
    
    var body: some View {
        VStack(alignment: .center) {
            TimePickerWheel(
                state: timePickerBinding,
                onTimeSelected: onTimeChange
            )
            .frame(width: 220, height: 180)
            
            Spacer().frame(height: 16)
            
            AlarmSetupItemRepeat(
                selectedDays: uiState.repeatDays,
                onItemClick: onRepeatClick
            )
            .frame(height: itemHeight)
            
            AlarmSetupItemLabel(
                value: $uiState.label,
                onTextChange: onLabelChange
            )
            .frame(height: itemHeight)
            
            AlarmSetupItemAudio(
                audio: uiState.audio,
                onItemClick: onAudioClick
            )
            .frame(height: itemHeight)
            
            AlarmSetupSnoozeView(
                isEnabled: $uiState.snoozeEnabled, // Replace with binding if needed
                onCheckedChange: onSnoozeChange
            )
            .frame(height: itemHeight)
            
            if !uiState.isNewAlarm {
                Text(R.string.localizable.delete())
                    .font(.body)
                    .foregroundColor(Color(red: 252/255, green: 43/255, blue: 15/255))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: itemHeight)
                    .padding(.top, 4)
                    .onTapGesture {
                        onDeleteClick()
                    }
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct AlarmSetupItemRepeat: View {
    let selectedDays: [Int]
    let onItemClick: () -> Void
    
    var body: some View {
        let text = getAlarmRepeatDisplayText(selectedDays, defaultText: R.string.localizable.never())
        AlarmSetupItemView(
            title: R.string.localizable.repeat(),
            value: text,
            onItemClick: onItemClick
        )
    }
}

private struct AlarmSetupItemAudio: View {
    let audio: AlarmAudioModel?
    let onItemClick: () -> Void
    
    var body: some View {
        AlarmSetupItemView(
            title: R.string.localizable.sound(),
            value: audio?.title ?? "",
            onItemClick: onItemClick
        )
    }
}
