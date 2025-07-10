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
            
            ForEach(alarms, id: \.id) { alarm in
                SwipeToDeleteItem(
                    alarm: alarm,
                    onDelete: onDelete,
                    onCheckedChange: onCheckedChange,
                    onItemClick: onClick
                )
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.automatic)
    }
}

struct SwipeToDeleteItem: View {
    let alarm: AlarmModel
    var onDelete: (AlarmModel) -> Void
    var onCheckedChange: (AlarmModel) -> Void
    var onItemClick: (AlarmModel) -> Void
    
    var body: some View {
        AlarmItemView(
            alarm: alarm,
            onCheckedChange: { _ in onCheckedChange(alarm) },
            onItemClick: { onItemClick(alarm) }
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete(alarm)
            } label: {
                Label(R.string.localizable.delete(), systemImage: "trash")
            }
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
            }
            .frame(height: 76)
        }
    }
    
    private func getDisplayText(alarm: AlarmModel) -> String {
        let repeatText = getAlarmRepeatDisplayText(fromRepeatDayString(alarm.repeatDays.orEmpty()))
        return repeatText.isEmpty ? alarm.label ?? "" : "\(alarm.label ?? ""), \(repeatText)"
    }
}
