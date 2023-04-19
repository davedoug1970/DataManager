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

    var dataSource: UITableViewDiffableDataSource<Section,Person>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                dataSource.apply(createSnapshot(), animatingDifferences: true)
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
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, person) -> UITableViewCell? in
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
}
