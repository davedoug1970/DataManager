//
//  PersonTableViewController.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import UIKit

class PersonTableViewController: UITableViewController {
    enum Section: CaseIterable {
        case main
    }

    // Subclassing our data source to supply various UITableViewDataSource methods
    class DataSource: UITableViewDiffableDataSource<Section, Person> {
        // MARK: editing support

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // determine which record needs to be deleted.
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    // remove that record from your source of the data
                    if PersonDataManager.shared.delete(id: identifierToDelete.id) {
                        // if that is successful, remove the record from the uitableview's source of data.
                        var snapshot = self.snapshot()
                        snapshot.deleteItems([identifierToDelete])
                        apply(snapshot)
                    }
                }
            }
        }
    }
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }

    @IBAction func unwindToPersonTableView(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? PersonDetailViewController,
            let person = sourceViewController.person else { return }
        
        if sourceViewController.changeType == .edit {
            // update the record in your source of data
            if PersonDataManager.shared.update(item: person) {
                // if that is succesful, update the record in the uitableview's source of data
                dataSource.applySnapshotUsingReloadData(createSnapshot())
            }
        } else {
            // add the new record to your source of data
            if PersonDataManager.shared.add(item: person) {
                // if that is successful, add the record to the uitableview's source of data
                dataSource.apply(updateSnapshot(person: person), animatingDifferences: true)
            }
        }
    }

    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> PersonDetailViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = PersonDataManager.shared.fetch()[indexPath.row]
            return PersonDetailViewController(coder: coder, person: personToEdit)
        } else {
            return PersonDetailViewController(coder: coder, person: nil)
        }
    }
    
    // MARK: - Configure Data Source
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { (tableView, indexPath, person) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
            cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
            cell.detailTextLabel?.text = "\(person.address.streetAddress), \(person.address.city), \(person.address.state), \(person.address.postalCode)"

            return cell
        }
        
        // initial data

        dataSource.apply(createSnapshot(), animatingDifferences: false)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Person> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Person>()
        snapshot.appendSections([.main])
        
        // First use of datamanager here will cause it to load all data from file.
        // The file will either be in the bundle or the documents directory depending on how
        // the datamanager is configured.
        
        snapshot.appendItems(PersonDataManager.shared.fetch())
        return snapshot
    }
    
    func updateSnapshot(person: Person) -> NSDiffableDataSourceSnapshot<Section, Person> {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([person], toSection: .main)
        return snapshot
    }
}
