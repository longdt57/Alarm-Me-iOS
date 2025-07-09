//
//  AlarmAudioModel.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import Foundation
import RealmSwift

public class AlarmAudioModel: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var durationS: Int?
    @Persisted var fileUrl: String?
    @Persisted var title: String?
    
    // Codable keys (optional if JSON matches property names)
    private enum CodingKeys: String, CodingKey {
        case id, durationS = "duration_s", fileUrl = "file_url", title
    }
    
    // MARK: - Custom Initializer
    convenience init(id: Int, durationS: Int?, fileUrl: String?, title: String?) {
        self.init()
        self.id = id
        self.durationS = durationS
        self.fileUrl = fileUrl
        self.title = title
    }
}
