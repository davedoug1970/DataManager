//
//  AddressRM.swift
//  DataManager
//
//  Created by David Douglas on 5/18/23.
//

import Foundation
import RealmSwift

class AddressRM: Object {
    @Persisted var streetAddress: String
    @Persisted var city: String
    @Persisted var state: String
    @Persisted var postalCode: String
    
    convenience init(streetAddress: String, city: String, state: String, postalCode: String) {
        self.init()
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.postalCode = postalCode
    }
}
