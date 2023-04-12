//
//  RemotePersonDetailTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 4/12/23.
//

import UIKit

class RemotePersonDetailTableViewController: UITableViewController {
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
            
            title = "Edit Person (remote)"
        } else {
            title = "Add Person (remote)"
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "saveUnwind" else { return }
        
        // if person has been set, we are editing...
        if person != nil {
            person!.firstName = firstNameTextField.text!
            person!.lastName = lastNameTextField.text!
            
            switch genderTextField.text! {
            case "male":
                person!.gender = .male
            case "female":
                person!.gender = .female
            default:
                person!.gender = .male
            }
            
            person!.age = Int(ageTextField.text!)!
            person!.address.streetAddress = streetAddressTextField.text!
            person!.address.city = cityTextField.text!
            person!.address.state = stateTextField.text!
            person!.address.postalCode = postalCodeTextField.text!
            
            switch phoneTypeTextField.text! {
            case "home":
                person!.phoneNumbers[0].type = .home
            case "work":
                person!.phoneNumbers[0].type = .work
            default:
                person!.phoneNumbers[0].type = .home
            }
          
            person!.phoneNumbers[0].number = phoneNumberTextField.text!
        } else {
            var gender: Gender = .male
            
            if genderTextField.text! == "female" {
                gender = .female
            }
            
            let tempAddress = Address(streetAddress: streetAddressTextField.text!, city: cityTextField.text!, state: stateTextField.text!, postalCode: postalCodeTextField.text!)
            
            var phoneType: PhoneType = .home
            
            if phoneTypeTextField.text! == "work" {
                phoneType = .work
            }
            
            let tempPhoneNumber = PhoneNumber(type: phoneType, number: phoneNumberTextField.text!)
            
            person = Person(id: UUID(), firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, gender: gender, age: Int(ageTextField.text!)!, address: tempAddress, phoneNumbers: [tempPhoneNumber])
        }
    }

}
