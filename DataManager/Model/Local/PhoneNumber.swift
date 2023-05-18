//
//  PhoneNumber.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import Foundation

struct PhoneNumber: Codable {
    var type: PhoneType
    var number: String
}

enum PhoneType: String, Codable {
    case home
    case work
}
