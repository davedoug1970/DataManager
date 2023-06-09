//
//  PersonCoreDataTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 5/2/23.
//
//  this article was very helpful.
//  https://cynoteck.com/blog-post/core-data-with-swift/
//

import UIKit
import CoreData

class PersonCoreDataTableViewController: UITableViewController {
    var people:[NSManagedObject] = []
    
    // used for core data requests
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Test Data - if this is your first run through, uncomment below to load
        // some test data.
        //
        // DataLoader.loadInitialData()
        
        // initial creation of context object, will be used for other requests...
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCD")
        request.returnsObjectsAsFaults = false
        
        do {
            people = try context.fetch(request) as! [NSManagedObject]
        } catch {
            print("Failed")
        }
    }
    
    @IBAction func unwindToPersonCDTableView(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? PersonCoreDataDetailViewController,
            let person = sourceViewController.person else { return }
        
        if sourceViewController.result != .success {
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // add the new record to your source of data
            let newIndexPath = IndexPath(row: people.count, section: 0)
            people.append(person)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> PersonCoreDataDetailViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = people[indexPath.row] as! PersonCD
            return PersonCoreDataDetailViewController(coder: coder, person: personToEdit)
        } else {
            return PersonCoreDataDetailViewController(coder: coder, person: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCD", for: indexPath)

        // Configure the cell...
        let person = people[indexPath.row]

        cell.textLabel?.text = "\(person.value(forKey: "firstName")!) \(person.value(forKey:"lastName")!)"
        cell.detailTextLabel?.text = "\(person.value(forKey: "streetAddress")!), \(person.value(forKey:"city")!), \(person.value(forKey: "state")!), \(person.value(forKey: "postalCode")!)"

        return cell
    }

    // MARK: - Table view delete support
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(people[indexPath.row])
            do {
                // apply the delete to core data...
                try context.save()
                // remove row from local array...
                self.people.remove(at: indexPath.row)
                // update the ui with the change...
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                print("record deleted successfully")
            }
            catch {
                // error occured in applying the delete to core data
                print(error.localizedDescription)
            }
        }
    }
}
