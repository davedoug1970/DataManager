//
//  PhoneNumberRM.swift
//  DataManager
//
//  Created by David Douglas on 5/18/23.
//

import Foundation
import RealmSwift

class PhoneNumberRM: Object {
    @Persisted var type: PhoneTypeRM
    @Persisted var number: String
    
    convenience init(type: PhoneTypeRM, number: String) {
        self.init()
        self.type = type
        self.number = number
    }
}

enum PhoneTypeRM: String, PersistableEnum {
    case home
    case work
}
