//
//  AlarmAudioModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import RealmSwift

class AlarmAudioModel: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var durationS: Int?
    @Persisted var fileUrl: String?
    @Persisted var title: String?
    
    // Codable keys (optional if JSON matches property names)
    private enum CodingKeys: String, CodingKey {
        case id, durationS = "duration_s", fileUrl = "file_url", title
    }
}
