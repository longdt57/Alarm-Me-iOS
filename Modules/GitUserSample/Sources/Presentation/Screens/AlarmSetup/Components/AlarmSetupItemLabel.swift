//
//  AlarmSetupItemLabel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import SwiftUI

struct AlarmSetupItemLabel: View {
    @Binding var value: String
    var onTextChange: (String) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(R.string.localizable.label())
                .font(.body)
                .padding(.leading, 8)
            
            ZStack(alignment: .trailing) {
                if value.isEmpty {
                    Text(R.string.localizable.optional())
                        .foregroundColor(.gray)
                        .font(.body)
                        .multilineTextAlignment(.trailing)
                }
                
                TextField("", text: Binding(
                    get: { value },
                    set: { newValue in
                        value = newValue
                        onTextChange(newValue)
                    })
                )
                .multilineTextAlignment(.trailing)
                .foregroundColor(.black)
                .font(.body)
            }
            .padding(.horizontal, 8)
        }
    }
}
#Preview {
    AlarmSetupItemLabel(value: .constant(""), onTextChange: { _ in })
}
