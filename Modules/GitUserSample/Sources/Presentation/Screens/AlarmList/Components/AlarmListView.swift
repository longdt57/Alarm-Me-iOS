//
//  AlarmListView.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

struct AlarmListView: View {
    let alarms: [AlarmModel]
    var onDelete: (AlarmModel) -> Void = { _ in }
    var onCheckedChange: (AlarmModel) -> Void = { _ in }
    var onClick: (AlarmModel) -> Void = { _ in }
    
    var body: some View {
        List {
            Spacer().frame(height: 24)
            
            ForEach(alarms, id: \.id) { alarm in
                SwipeToDeleteItem(
                    alarm: alarm,
                    onDelete: onDelete,
                    onCheckedChange: onCheckedChange,
                    onItemClick: onClick
                )
                .listRowSeparator(.hidden)
            }
            
            Spacer().frame(height: 24)
        }
        .listStyle(.plain)
    }
}

struct SwipeToDeleteItem: View {
    let alarm: AlarmModel
    var onDelete: (AlarmModel) -> Void
    var onCheckedChange: (AlarmModel) -> Void
    var onItemClick: (AlarmModel) -> Void
    
    var body: some View {
        ZStack {
            // Red background delete button
            HStack {
                Spacer()
                Button(action: { onDelete(alarm) }) {
                    Text("Delete")
                        .frame(width: 80, height: 76)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            
            // Foreground alarm item
            AlarmItemView(
                alarm: alarm,
                onCheckedChange: { _ in onCheckedChange(alarm) },
                onItemClick: { onItemClick(alarm) }
            )
            .background(Color.white)
        }
        .padding(.horizontal, 16)
    }
}

struct AlarmItemView: View {
    let alarm: AlarmModel
    var onCheckedChange: (Bool) -> Void
    var onItemClick: () -> Void
    
    var body: some View {
        VStack {
            Button(action: onItemClick) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(alarm.displayTime)
                            .font(.title2)
                            .bold()
                        
                        if let label = alarm.label, !label.isEmpty {
                            Text(getDisplayText(alarm: alarm))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { alarm.isEnabled },
                        set: { onCheckedChange($0) }
                    ))
                    .labelsHidden()
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 32)
            }
            
            Divider().padding(.horizontal, 32)
        }
    }
    
    private func getDisplayText(alarm: AlarmModel) -> String {
        let repeatText = getAlarmRepeatDisplayText(Array(alarm.repeatDays))
        return repeatText.isEmpty ? alarm.label ?? "" : "\(alarm.label ?? ""), \(repeatText)"
    }
}
