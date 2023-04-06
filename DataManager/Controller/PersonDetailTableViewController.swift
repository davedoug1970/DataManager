//
//  PersonDetailTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 4/5/23.
//

import UIKit

class PersonDetailTableViewController: UITableViewController {
    
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
   
    
    var person: Person?
    
    init?(coder: NSCoder, person: Person?) {
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
            genderTextField.text = editPerson.gender.rawValue
            ageTextField.text = String(editPerson.age)
            streetAddressTextField.text = editPerson.address.streetAddress
            cityTextField.text = editPerson.address.city
            stateTextField.text = editPerson.address.state
            postalCodeTextField.text = editPerson.address.postalCode
            phoneTypeTextField.text = editPerson.phoneNumbers[0].type.rawValue
            phoneNumberTextField.text = editPerson.phoneNumbers[0].number
            
            title = "Edit Person"
        } else {
            title = "Add Person"
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "saveUnwind" else { return }
        
        // if person has been set, we are editing...
        if let editPerson = person {
            person!.firstName = firstNameTextField.text!
            person!.lastName = lastNameTextField.text!
            
            switch genderTextField.text! {
            case "Male":
                person!.gender = .Male
            case "Female":
                person!.gender = .Female
            default:
                person!.gender = .Male
            }
            
            person!.age = Int(ageTextField.text!)!
            person!.address.streetAddress = streetAddressTextField.text!
            person!.address.city = cityTextField.text!
            person!.address.state = stateTextField.text!
            person!.address.postalCode = postalCodeTextField.text!
            
            switch phoneTypeTextField.text! {
            case "Home":
                person!.phoneNumbers[0].type = .Home
            case "Work":
                person!.phoneNumbers[0].type = .Work
            default:
                person!.phoneNumbers[0].type = .Home
            }
          
            person!.phoneNumbers[0].number = phoneNumberTextField.text!
        } else {
            var gender: Gender = .Male
            
            if genderTextField.text! == "Female" {
                gender = .Female
            }
            
            let tempAddress = Address(streetAddress: streetAddressTextField.text!, city: cityTextField.text!, state: stateTextField.text!, postalCode: postalCodeTextField.text!)
            
            var phoneType: PhoneType = .Home
            
            if phoneTypeTextField.text! == "Work" {
                phoneType = .Work
            }
            
            let tempPhoneNumber = PhoneNumber(type: phoneType, number: phoneNumberTextField.text!)
            
            person = Person(id: UUID(), firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, gender: gender, age: Int(ageTextField.text!)!, address: tempAddress, phoneNumbers: [tempPhoneNumber])
        }
    }

}