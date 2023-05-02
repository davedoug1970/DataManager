//
//  PersonCD+CoreDataProperties.swift
//  DataManager
//
//  Created by David Douglas on 5/2/23.
//
//

import Foundation
import CoreData


extension PersonCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonCD> {
        return NSFetchRequest<PersonCD>(entityName: "PersonCD")
    }

    @NSManaged public var age: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var gender: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var personToPhoneNumber: NSSet?

}

// MARK: Generated accessors for personToPhoneNumber
extension PersonCD {

    @objc(addPersonToPhoneNumberObject:)
    @NSManaged public func addToPersonToPhoneNumber(_ value: PhoneNumberCD)

    @objc(removePersonToPhoneNumberObject:)
    @NSManaged public func removeFromPersonToPhoneNumber(_ value: PhoneNumberCD)

    @objc(addPersonToPhoneNumber:)
    @NSManaged public func addToPersonToPhoneNumber(_ values: NSSet)

    @objc(removePersonToPhoneNumber:)
    @NSManaged public func removeFromPersonToPhoneNumber(_ values: NSSet)

}

extension PersonCD : Identifiable {

}
