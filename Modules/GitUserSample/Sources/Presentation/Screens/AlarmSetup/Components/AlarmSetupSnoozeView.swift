//
//  AlarmSetupSnoozeView.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

struct AlarmSetupSnoozeView: View {
    @Binding var isEnabled: Bool
    
    let onCheckedChange: (Bool) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(R.string.localizable.snooze())
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
                .padding(.leading, 8)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    AlarmSetupSnoozeView(
        isEnabled: .constant(Bool.random()),
        onCheckedChange: { _ in }
    )
}
