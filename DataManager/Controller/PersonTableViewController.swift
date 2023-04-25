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
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    if PersonDataManager.shared.delete(id: identifierToDelete.id) {
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
            let sourceViewController = segue.source as? PersonDetailTableViewController,
            let person = sourceViewController.person else { return }
        
        if sourceViewController.changeType == .edit {
            if PersonDataManager.shared.update(item: person) {
                dataSource.applySnapshotUsingReloadData(createSnapshot())
            }
        } else {
            if PersonDataManager.shared.add(item: person) {
                dataSource.apply(updateSnapshot(person: person), animatingDifferences: true)
            }
        }
    }
    
    @IBSegueAction func addEditPerson(_ coder: NSCoder, sender: Any?) -> PersonDetailTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let personToEdit = PersonDataManager.shared.fetch()[indexPath.row]
            return PersonDetailTableViewController(coder: coder, person: personToEdit)
        } else {
            return PersonDetailTableViewController(coder: coder, person: nil)
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
        snapshot.appendItems(PersonDataManager.shared.fetch())
        return snapshot
    }
    
    func updateSnapshot(person: Person) -> NSDiffableDataSourceSnapshot<Section, Person> {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([person], toSection: .main)
        return snapshot
    }
}
