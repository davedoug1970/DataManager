//
//  PersonRealmTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 5/18/23.
//
//  https://www.mongodb.com/docs/realm/sdk/swift/quick-start/
//  

import UIKit
import RealmSwift

class PersonRealmTableViewController: UITableViewController {
    var people:[PersonRM] = []
    // open the local-only default realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Test Data - if this is your first run through, uncomment below to load
        // some test data.
        //
        // RealmLoader.loadInitialData()
        
        // get person objects
        let results = realm.objects(PersonRM.self)
        results.forEach { person in
            people.append(person)
        }
    }

    @IBAction func unwindToPersonRMTableView(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? PersonRealmDetailViewController,
            let person = sourceViewController.person else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // update local collection...
            people[selectedIndexPath.row] = person
            
            // update table view
            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // add the new record to your source of data
            do {
                try realm.write {
                    realm.add(person)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            let newIndexPath = IndexPath(row: self.people.count, section: 0)
            
            // add person to local collection
            people.append(person)
            
            // update table view
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> PersonRealmDetailViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = people[indexPath.row]
            return PersonRealmDetailViewController(coder: coder, person: personToEdit)
        } else {
            return PersonRealmDetailViewController(coder: coder, person: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personRM", for: indexPath)

        // Configure the cell...
        let person = people[indexPath.row]
        
        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        
        if let address = person.address {
            cell.detailTextLabel?.text = "\(address.streetAddress), \(address.city), \(address.state), \(address.postalCode)"
        }

        return cell
    }

    // MARK: - Table view delete support
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let personToDelete = people[indexPath.row]
            do {
                // update source of data...
                try realm.write {
                    // delete the person
                    realm.delete(personToDelete)
                }
            
                // update local collection...
                people.remove(at: indexPath.row)
                
                // update table view
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                print("record deleted successfully")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
