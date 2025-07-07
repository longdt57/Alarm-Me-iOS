//
//  LinkText.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

public struct LinkText: View {
    var url: String

    public init(url: String) {
        self.url = url
    }

    public var body: some View {
        Text(url)
            .foregroundColor(.blue)
            .underline()
            .onTapGesture {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            }
    }
}

struct LinkText_Previews: PreviewProvider {
    static var previews: some View {
        LinkText(url: "https://github.com/longdt57")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
