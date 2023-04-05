//
//  Person.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import Foundation

struct Person: Codable, Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var gender: Gender
    var age: Int
    var address: Address
    var phoneNumbers: [PhoneNumber]
}

enum Gender: String, Codable {
   case Male
   case Female
}


