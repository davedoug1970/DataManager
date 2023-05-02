//
//  PersonCoreDataTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 5/2/23.
//

import UIKit
import CoreData

class PersonCoreDataTableViewController: UITableViewController {
    var people:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Test Data - if this is your first run through, uncomment below to load
        // some test data.
        //
        //DataLoader.loadInitialData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCD")
        request.returnsObjectsAsFaults = false
        
        do {
            people = try context.fetch(request) as! [NSManagedObject]
        } catch {
            print("Failed")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
