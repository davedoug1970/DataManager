//
//  RemotePersonTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 4/12/23.
//
//  This class uses a companion docker image that can be retrieved here:
//  https://hub.docker.com/r/davedoug1970/swiftpersonapi
//  source code is here: https://github.com/davedoug1970/swift-person-api

import UIKit

class RemotePersonTableViewController: UITableViewController {
    let dataManager = RemoteDataManager<Person>(baseURL: "http://localhost:8080/api/v1/persons", fetchAllEndPoint: "", fetchEndPoint: "/", addEndPoint: "/add", updateEndPoint: "/update", deleteEndPoint: "/delete/")
    var people: [Person] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.fetchItems(matching: [:], queryType: .url) { (result) in
            switch result {
            case .success(let peopleItems):
                self.people = peopleItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func unwindToRemotePersonTableView(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? RemotePersonDetailTableViewController,
            let person = sourceViewController.person else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            dataManager.updateItem(item: person) { (result) in
                switch result {
                case .success(let success):
                    if success {
                        if let replacementSub = self.people.firstIndex(of: person) {
                            self.people[replacementSub] = person
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                            }
                            print("record updated successfully")
                        } else {
                            print("there was an issue updating the record")
                        }
                    } else {
                        print("there was an issue updating the record")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            dataManager.addItem(item: person) { (result) in
                switch result {
                case .success(let success):
                    if success {
                        let newIndexPath = IndexPath(row: self.people.count, section: 0)
                        self.people.append(person)
                        DispatchQueue.main.async {
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        }
                        print("record added successfully")
                    } else {
                        print("there was an issue adding the record")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> RemotePersonDetailTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = people[indexPath.row]
            return RemotePersonDetailTableViewController(coder: coder, person: personToEdit)
        } else {
            return RemotePersonDetailTableViewController(coder: coder, person: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)

        let person = people[indexPath.row]

        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        cell.detailTextLabel?.text = "\(person.address.streetAddress), \(person.address.city), \(person.address.state), \(person.address.postalCode)"

        return cell
    }
    
    // MARK: - Table view delete support
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.deleteItem(id: people[indexPath.row].id) { (result) in
                switch result {
                case .success(let success):
                    if success {
                        self.people.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        print("record deleted successfully")
                    } else {
                        print("there was an issue deleting the record")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
