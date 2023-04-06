//
//  PersonTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import UIKit

class PersonTableViewController: UITableViewController {
    let dataManager = DataManager<Person>(persistanceStrategy: JsonPersistable(), readonly: false)
           
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func unwindToPersonTableView(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? PersonDetailTableViewController,
            let person = sourceViewController.person else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if dataManager.update(item: person) {
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        } else {
            let newIndexPath = IndexPath(row: dataManager.fetch().count, section: 0)
            if dataManager.add(item: person) {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> PersonDetailTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = dataManager.fetch()[indexPath.row]
             return PersonDetailTableViewController(coder: coder, person: personToEdit)
        } else {
            return PersonDetailTableViewController(coder: coder, person: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.fetch().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let person = dataManager.fetch()[indexPath.row]
        
        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        cell.detailTextLabel?.text = "\(person.address.streetAddress), \(person.address.city), \(person.address.state), \(person.address.postalCode)"

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
