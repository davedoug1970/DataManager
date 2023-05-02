//
//  DataLoader.swift
//  DataManager
//
//  Created by David Douglas on 5/2/23.
//

import Foundation
import CoreData
import UIKit

struct DataLoader {
    static func loadInitialData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entityPerson = NSEntityDescription.entity(forEntityName: "PersonCD", in: context)
        let entityPhoneNumber = NSEntityDescription.entity(forEntityName: "PhoneNumberCD", in: context)
        
        // First Record...
        
        let newPerson1 = NSManagedObject(entity: entityPerson!, insertInto: context)
        
        newPerson1.setValue("John", forKey: "firstName")
        newPerson1.setValue("Doe", forKey: "lastName")
        newPerson1.setValue("male", forKey: "gender")
        newPerson1.setValue(24, forKey: "age")
        newPerson1.setValue("126 Main Street", forKey: "streetAddress")
        newPerson1.setValue("San Jone", forKey: "city")
        newPerson1.setValue("CA", forKey: "state")
        newPerson1.setValue("39221", forKey: "postalCode")
        
        let newPhoneNumber1 = NSManagedObject(entity: entityPhoneNumber!, insertInto: context)

        newPhoneNumber1.setValue("home", forKey: "type")
        newPhoneNumber1.setValue("7383627627", forKey: "number")
        
        let phoneNumbers1 = NSSet(array: [newPhoneNumber1])
        
        newPerson1.setValue(phoneNumbers1, forKey: "personToPhoneNumber")
        
        // Second Record...
        
        let newPerson2 = NSManagedObject(entity: entityPerson!, insertInto: context)
        
        newPerson2.setValue("Jane", forKey: "firstName")
        newPerson2.setValue("Doe", forKey: "lastName")
        newPerson2.setValue("female", forKey: "gender")
        newPerson2.setValue(23, forKey: "age")
        newPerson2.setValue("200 Somewhere Street", forKey: "streetAddress")
        newPerson2.setValue("Mobile", forKey: "city")
        newPerson2.setValue("AL", forKey: "state")
        newPerson2.setValue("36695", forKey: "postalCode")
        
        let newPhoneNumber2 = NSManagedObject(entity: entityPhoneNumber!, insertInto: context)

        newPhoneNumber2.setValue("home", forKey: "type")
        newPhoneNumber2.setValue("2513627627", forKey: "number")
        
        let phoneNumbers2 = NSSet(array: [newPhoneNumber2])
        
        newPerson2.setValue(phoneNumbers2, forKey: "personToPhoneNumber")
        
        // Third Record...
        
        let newPerson3 = NSManagedObject(entity: entityPerson!, insertInto: context)
        
        newPerson3.setValue("Bubba", forKey: "firstName")
        newPerson3.setValue("Jones", forKey: "lastName")
        newPerson3.setValue("male", forKey: "gender")
        newPerson3.setValue(28, forKey: "age")
        newPerson3.setValue("126 Anywhere Blvd", forKey: "streetAddress")
        newPerson3.setValue("Birmingham", forKey: "city")
        newPerson3.setValue("AL", forKey: "state")
        newPerson3.setValue("35022", forKey: "postalCode")
        
        let newPhoneNumber3 = NSManagedObject(entity: entityPhoneNumber!, insertInto: context)

        newPhoneNumber3.setValue("home", forKey: "type")
        newPhoneNumber3.setValue("2053627627", forKey: "number")
        
        let phoneNumbers3 = NSSet(array: [newPhoneNumber3])
        
        newPerson3.setValue(phoneNumbers3, forKey: "personToPhoneNumber")
        
        // save the data...
        
        do {
            try context.save()
         } catch {
             print("Error saving")
             print(error.localizedDescription)
        }
    }
}
