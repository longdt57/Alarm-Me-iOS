//
//  AlarmLocalSource.swift
//  iOSApp
//
//  Created by Long Do on 9/7/25.
//

import RealmSwift

protocol AlarmLocalSource {
    func observeAlarms() -> Results<AlarmModel>
    func getEnabledAlarms() -> [AlarmModel]
    func getAlarmById(_ id: Int) -> AlarmModel?
    func upsert(_ alarm: AlarmModel) throws
    func deleteById(_ id: Int) throws
    func setEnable(_ id: Int, _ enable: Bool) throws
}

class AlarmLocalSourceImpl: AlarmLocalSource {
    init() {}
    
    private func getRealm() throws -> Realm {
        try Realm()
    }
    
    func observeAlarms() -> Results<AlarmModel> {
        let realm = try! getRealm()
        return realm.objects(AlarmModel.self)
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
            realm.add(alarm, update: .modified)
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
