//
//  AppHorizontalDivider.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

public struct AppHorizontalDivider: View {
    var thickness: CGFloat
    var color: Color

    public init(thickness: CGFloat = 1, color: Color = Color.gray.opacity(0.2)) {
        self.thickness = thickness
        self.color = color
    }

    public var body: some View {
        Divider()
            .frame(height: thickness)
            .background(color)
    }
}

struct AppHorizontalDivider_Previews: PreviewProvider {
    static var previews: some View {
        AppHorizontalDivider()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
