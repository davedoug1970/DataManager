//
//  Person.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import Foundation

// Hashable protocol added to support diffable datasource
struct Person: Codable, Identifiable, Hashable {
    var id: UUID
    var firstName: String
    var lastName: String
    var gender: Gender
    var age: Int
    var address: Address
    var phoneNumbers: [PhoneNumber]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Gender: String, Codable {
    case male
    case female
    case transgender
    case nonBinaryNonConforming
    case noResponse
}


