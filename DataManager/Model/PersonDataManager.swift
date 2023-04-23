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
    
    // private init means the only way to initialize this class is through the static shared variable 
    private init() {

    }
}