//
//  PhoneNumberCD+CoreDataProperties.swift
//  DataManager
//
//  Created by David Douglas on 5/2/23.
//
//

import Foundation
import CoreData


extension PhoneNumberCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumberCD> {
        return NSFetchRequest<PhoneNumberCD>(entityName: "PhoneNumberCD")
    }

    @NSManaged public var type: String?
    @NSManaged public var number: String?

}

extension PhoneNumberCD : Identifiable {

}
