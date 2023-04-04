//
//  PersonDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import Foundation

class PersonDataManager: DataManager {
    typealias T = Person
    
    private var data: [T] = []
    
    static let shared = PersonDataManager()
    
    private init () {
        data =  []
    }
    
    func fetch() -> [T] {
        return data
    }
    
    func fetch(id: T.ID) -> T? {
        if let firstPerson = data.first(where: { $0.id == id }) {
            return firstPerson
        }
        return nil
    }
    
    func update(item: T) -> Bool {
        if let i = data.firstIndex(where: { $0.id == item.id }) {
            data[i] = item
            return save()
        }
        return false
    }
    
    func delete(id: T.ID) -> Bool {
        if let i = data.firstIndex(where: { $0.id == id }) {
            data.remove(at: i)
            return save()
        }
        return false
    }
    
    func add(item: T) -> Bool {
        data.append(item)
        return save()
    }
    
    func save() -> Bool {
        return false
        //return JsonPersistable.save(data: data, readonly: false)
    }
}
