//
//  PersonDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/13/23.
//

import Foundation

class PersonDataManager: SharedDataManager {
    typealias T = Person
    
    static let shared = DataManager<T>(persistanceStrategy: JsonPersistable(), readonly: true)
    
    private init() {

    }
}
