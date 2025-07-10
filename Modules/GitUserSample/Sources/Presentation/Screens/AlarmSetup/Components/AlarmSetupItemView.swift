//
//  AlarmSetupItemView.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

struct AlarmSetupItemView: View {
    var title: String
    var value: String
    var onItemClick: () -> Void = {}
    
    var body: some View {
        Button(action: {
            onItemClick()
        }) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.body)
                    .lineLimit(1)
                
                Spacer(minLength: 16)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(Color.primary.opacity(0.7))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 8)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
}

#Preview {
    AlarmSetupItemView(title: "Test", value: "Test")
}