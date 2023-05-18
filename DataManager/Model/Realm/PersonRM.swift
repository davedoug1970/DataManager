//
//  PersonRM.swift
//  DataManager
//
//  Created by David Douglas on 5/18/23.
//
//  https://www.mongodb.com/docs/realm/sdk/swift/model-data/object-models/
//

import Foundation
import RealmSwift

class PersonRM: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var gender: GenderRM
    @Persisted var age: Int
    @Persisted var address: AddressRM?
    @Persisted var phoneNumbers: List<PhoneNumberRM>
    
    static func == (lhs: PersonRM, rhs: PersonRM) -> Bool {
        return lhs.id == rhs.id
    }
    
    convenience init(id: ObjectId, firstName: String, lastName: String, gender: GenderRM, age: Int, address: AddressRM, phoneNumbers: List<PhoneNumberRM>) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.age = age
        self.address = address
        self.phoneNumbers = phoneNumbers
    }
}

enum GenderRM: String, PersistableEnum {
    case male
    case female
    case transgender
    case nonBinaryNonConforming
    case noResponse
}
