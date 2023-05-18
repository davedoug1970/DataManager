//
//  PersonDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/13/23.
//

import Foundation

class PersonDataManager: SharedDataManager {
    typealias T = Person
    
    // change persistance strategy to use a plist or json file.
    // change readonly to either manage entities only in memory or to write changes back to disk.
    static let shared = DataManager<T>(persistanceStrategy: PlistPersistable(), readonly: false)
    
    // private init means the only way to initialize this class is through the static shared variable 
    private init() {

    }
}
