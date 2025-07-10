//
//  AlarmLocalSource.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import RealmSwift
import Combine

protocol AlarmLocalSource {
    func observeAlarms() -> AnyPublisher<[AlarmModel], Error>
    func getEnabledAlarms() -> [AlarmModel]
    func getAlarmById(_ id: Int) -> AlarmModel?
    func upsert(_ alarm: AlarmModel) throws
    func deleteById(_ id: Int) throws
    func setEnable(_ id: Int, _ enable: Bool) throws
}

public class AlarmLocalSourceImpl: AlarmLocalSource {
    public init() {}
    
    private func getRealm() throws -> Realm {
        try! Realm()
    }
    
    func observeAlarms() -> AnyPublisher<[AlarmModel], Error> {
        let realm = try! getRealm()
        let results = realm.objects(AlarmModel.self)
        
        return results
            .collectionPublisher
            .map { alarms in
                alarms.freeze().map { $0 } // freeze for thread-safety
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getEnabledAlarms() -> [AlarmModel] {
        let realm = try! getRealm()
        return Array(realm.objects(AlarmModel.self).filter("isEnabled == true"))
    }
    
    func getAlarmById(_ id: Int) -> AlarmModel? {
        let realm = try! getRealm()
        return realm.object(ofType: AlarmModel.self, forPrimaryKey: id)
    }
    
    func upsert(_ alarm: AlarmModel) throws {
        let realm = try getRealm()
        
        try realm.write {
            // ✅ Thaw the object if it's frozen
            guard let mutableAlarm = alarm.isFrozen ? alarm.thaw() : alarm else {
                throw NSError(domain: "Realm", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot thaw frozen object"])
            }
            
            // ✅ Set ID only if it's new
            if mutableAlarm.id == 0 {
                let maxId = realm.objects(AlarmModel.self).max(ofProperty: "id") as Int? ?? 0
                mutableAlarm.id = maxId + 1
            }
            
            // ✅ Add or update
            realm.add(mutableAlarm, update: .modified)
        }
    }


    
    func deleteById(_ id: Int) throws {
        let realm = try getRealm()
        if let alarm = realm.object(ofType: AlarmModel.self, forPrimaryKey: id) {
            try realm.write {
                realm.delete(alarm)
            }
        }
    }
    
    func setEnable(_ id: Int, _ enable: Bool) throws {
        let realm = try getRealm()
        if let alarm = realm.object(ofType: AlarmModel.self, forPrimaryKey: id) {
            try realm.write {
                alarm.isEnabled = enable
            }
        }
    }
}
