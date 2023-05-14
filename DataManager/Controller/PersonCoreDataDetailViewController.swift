//
//  PersonCoreDataDetailViewController.swift
//  DataManager
//
//  Created by David Douglas on 5/13/23.
//

import UIKit
import CoreData

class PersonCoreDataDetailViewController: UIViewController {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var streetAddressTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var postalCodeTextField: UITextField!
    @IBOutlet var phoneTypeTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    
    enum ResultType: String {
        case success
        case failure
        case cancel
        case notset
    }
    
    // used for core data requests
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    var person: PersonCD?
    var result: ResultType = .notset
    
    init?(coder: NSCoder, person: PersonCD?) {
        self.person = person
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let editPerson = person {
            // set text fields here...
            firstNameTextField.text = editPerson.firstName
            lastNameTextField.text = editPerson.lastName
            genderTextField.text = editPerson.gender
            ageTextField.text = String(editPerson.age)
            streetAddressTextField.text = editPerson.streetAddress
            cityTextField.text = editPerson.city
            stateTextField.text = editPerson.state
            postalCodeTextField.text = editPerson.postalCode
            
            if let phoneNumbers = Array(editPerson.personToPhoneNumber!) as? [PhoneNumberCD] {
                phoneTypeTextField.text = phoneNumbers[0].type
                phoneNumberTextField.text = phoneNumbers[0].number
            }
            
            title = "Edit Person (CoreData)"
        } else {
            title = "Add Person (CoreData)"
        }
        
        // initial creation of context object, will be used for other requests...
        context = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {
            result = .cancel
            return
        }
        
        // if person has been set, we are editing...
        if person != nil {
            // modify NSManagedObject on an edit...
            var phoneNumbers = NSSet()
            
            if let personToPhoneNumber = person!.personToPhoneNumber {
                let tempPhoneNumbers = Array(personToPhoneNumber) as! [NSManagedObject]
                setPhoneNumberValues(phoneNumber: tempPhoneNumbers[0])
                phoneNumbers = NSSet(array: tempPhoneNumbers)
            }
            
            setPersonValues(person: person!, phoneNumbers: phoneNumbers)
        } else {
            // get reference to PersonCD entity
            let entityPerson = NSEntityDescription.entity(forEntityName: "PersonCD", in: context)
            // get reference to PhoneNumberCD entity
            let entityPhoneNumber = NSEntityDescription.entity(forEntityName: "PhoneNumberCD", in: context)
            
            // use PhoneNumberCD entity to create new PhoneNumberCD NSManagedObject
            let newPhoneNumber = NSManagedObject(entity: entityPhoneNumber!, insertInto: context)
            // update new NSManagedObject with data from the view
            setPhoneNumberValues(phoneNumber: newPhoneNumber)
            let phoneNumbers = NSSet(array: [newPhoneNumber])
            
            // use PersonCD entity to create new PersonCD NSManagedObject
            let newPerson = NSManagedObject(entity: entityPerson!, insertInto: context)
            // update new NSManagedObject with data from the view and PhoneNumberCD NSManagedObject
            setPersonValues(person: newPerson, phoneNumbers: phoneNumbers)
            
            // set return value equal to the newly created PersonCD NSManagedObject
            self.person = newPerson as? PersonCD
        }
        
        do {
            // save changes to the context. Will handle either edit or add situation
            try context.save()
            result = .success
         } catch {
             print("Error saving")
             print(error.localizedDescription)
             result = .failure
        }
    }

    private func setPersonValues(person: NSManagedObject, phoneNumbers: NSSet) {
        person.setValue(firstNameTextField.text!, forKey: "firstName")
        person.setValue(lastNameTextField.text!, forKey: "lastName")
        person.setValue(genderTextField.text!.lowercased(), forKey: "gender")
        person.setValue(Int(ageTextField.text!)!, forKey: "age")
        person.setValue(streetAddressTextField.text!, forKey: "streetAddress")
        person.setValue(cityTextField.text!, forKey: "city")
        person.setValue(stateTextField.text!, forKey: "state")
        person.setValue(postalCodeTextField.text!, forKey: "postalCode")
        person.setValue(phoneNumbers, forKey: "personToPhoneNumber")
    }
    
    private func setPhoneNumberValues(phoneNumber: NSManagedObject) {
        phoneNumber.setValue(phoneTypeTextField.text!.lowercased(), forKey: "type")
        phoneNumber.setValue(phoneNumberTextField.text!, forKey: "number")
    }
    
}
