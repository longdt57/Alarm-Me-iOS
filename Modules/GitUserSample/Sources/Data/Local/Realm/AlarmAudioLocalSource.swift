//
//  AlarmAudioLocalSource.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import RealmSwift

protocol AlarmAudioLocalSource {
    func observeAlarmAudios() -> Results<AlarmAudioModel>
    func clearAll() throws
    func upsertAll(_ audios: [AlarmAudioModel]) throws
}

class AlarmAudioLocalSourceImpl: AlarmAudioLocalSource {
    public init() {}
    
    private func getRealm() throws -> Realm {
        try Realm()
    }
    
    func observeAlarmAudios() -> Results<AlarmAudioModel> {
        let realm = try! getRealm()
        return realm.objects(AlarmAudioModel.self)
    }
    
    func clearAll() throws {
        let realm = try getRealm()
        try realm.write {
            let all = realm.objects(AlarmAudioModel.self)
            realm.delete(all)
        }
    }
    
    func upsertAll(_ audios: [AlarmAudioModel]) throws {
        let realm = try getRealm()
        try realm.write {
            realm.add(audios, update: .modified)
        }
    }
}
