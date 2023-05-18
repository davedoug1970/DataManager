//
//  RealmLoader.swift
//  DataManager
//
//  Created by David Douglas on 5/18/23.
//

import Foundation
import RealmSwift

struct RealmLoader {
    static func loadInitialData() {
        let realm = try! Realm()
        
        let person1PhoneNumbers = List<PhoneNumberRM>()
        person1PhoneNumbers.append(PhoneNumberRM(type: .home, number: "7383627627"))
        let person1 = PersonRM(id: ObjectId.generate(), firstName: "John", lastName: "Doe", gender: .male, age: 24, address: AddressRM(streetAddress: "126 Main Street", city: "San Jone", state: "CA", postalCode: "39221"), phoneNumbers: person1PhoneNumbers)
        
        try! realm.write {
            realm.add(person1)
        }
        
        let person2PhoneNumbers = List<PhoneNumberRM>()
        person2PhoneNumbers.append(PhoneNumberRM(type: .home, number: "2513627627"))
        let person2 = PersonRM(id: ObjectId.generate(), firstName: "Jane", lastName: "Doe", gender: .female, age: 23, address: AddressRM(streetAddress: "200 Somewhere Street", city: "Mobile", state: "AL", postalCode: "36695"), phoneNumbers: person2PhoneNumbers)
        
        try! realm.write {
            realm.add(person2)
        }
        
        let person3PhoneNumbers = List<PhoneNumberRM>()
        person3PhoneNumbers.append(PhoneNumberRM(type: .home, number: "2053627627"))
        let person3 = PersonRM(id: ObjectId.generate(), firstName: "Bubba", lastName: "Jones", gender: .male, age: 28, address: AddressRM(streetAddress: "126 Anywhere Blvd", city: "Birmingham", state: "AL", postalCode: "35022"), phoneNumbers: person3PhoneNumbers)
        
        try! realm.write {
            realm.add(person3)
        }
    }
}
