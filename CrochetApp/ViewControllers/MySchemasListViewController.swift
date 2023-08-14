//
//  MySchemasListViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import UIKit
import CoreData

final class MySchemasListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    
//    private var fetchResultsController = StorageManager.shared.fetchedResultController(entityName: "Schema")
    
    private var savedSchemas: [Schema] = []
    private var filteringSchemas: [Schema] = []
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let searchText = searchVC.searchBar.text?.isEmpty else { return false }
        return searchText
    }
    private var isFiltering: Bool {
        searchVC.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        navigationItem.rightBarButtonItem = editButtonItem

//        fetchResultsController.delegate = self
//
//        do {
//            try fetchResultsController.performFetch()
//        } catch {
//            print(error)
//        }

        fetchSchemas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSchemas()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let schemaVC = segue.destination as? SchemaViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let setElements = savedSchemas[indexPath.row].elements as? Set<Element> else { return }
        let elements = Array(setElements)
        let name = savedSchemas[indexPath.row].name
        schemaVC.saveElements = elements
        schemaVC.nameOfSaveSchema = name
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteringSchemas.count : savedSchemas.count
//        fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedSchema", for: indexPath) as? ElementCell else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedSchema", for: indexPath)
        
//        guard let schema = getSchema(at: indexPath) else { return UITableViewCell() }
//
//        cell.contentConfiguration = cell.configure(with: schema)
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "dd MMMM YYYY, HH:mm"
        var content = cell.defaultContentConfiguration()
        if !isFiltering {
            content.text = savedSchemas[indexPath.row].name
            content.secondaryText = formatter.string(from: savedSchemas[indexPath.row].date)
        } else {
            content.text = filteringSchemas[indexPath.row].name
            content.secondaryText = filteringSchemas[indexPath.row].date.formatted(.iso8601)
        }
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        storageManager.refresh()
//        if sourceIndexPath.row > destinationIndexPath.row {
//            for i in destinationIndexPath.row..<sourceIndexPath.row {
//                savedSchemas[i].setValue(i + 1, forKey: "index")
//            }
//            savedSchemas[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "index")
//        } else if sourceIndexPath.row < destinationIndexPath.row {
//            for i in sourceIndexPath.row + 1...destinationIndexPath.row {
//                savedSchemas[i].setValue(i - 1, forKey: "index")
//            }
//            savedSchemas[sourceIndexPath.row].setValue(destinationIndexPath.row, forKey: "index")
//        }
//        storageManager.saveContext()
//        storageManager.refresh()
//        let saveSchema = savedSchemas.remove(at: sourceIndexPath.row)
//        savedSchemas.insert(saveSchema, at: destinationIndexPath.row)
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            guard let schema = getSchema(at: indexPath) else { return }
//            storageManager.delete(schema: schema)
            if isFiltering {
                storageManager.delete(schema: filteringSchemas[indexPath.row])
                filteringSchemas.remove(at: indexPath.row)
            } else {
                storageManager.delete(schema: savedSchemas[indexPath.row])
                savedSchemas.remove(at: indexPath.row)
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

//extension MySchemasListViewController: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let newIndexPath = newIndexPath else { return }
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//        case .delete:
//            guard let indexPath = indexPath else { return }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        case .move:
//            guard let indexPath = indexPath else { return }
//            guard let newIndexPath = newIndexPath else { return }
//
////            tableView.moveRow(at: indexPath, to: newIndexPath)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//
//        case .update:
//            guard let indexPath = indexPath else { return }
////            tableView.reloadRows(at: [indexPath], with: .automatic)
//            let cell = tableView.cellForRow(at: indexPath) as? ElementCell
//            guard let schema = getSchema(at: indexPath) else { return }
//            cell?.contentConfiguration = cell?.configure(with: schema)
//        default: break
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//
//}

extension MySchemasListViewController {
    private func fetchSchemas() {
        storageManager.fetchSchemas { result in
            switch result {
            case .success(let schemas):
                savedSchemas = schemas
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSearch() {
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
//    private func getSchema(at indexPath: IndexPath?) -> Schema? {
//        if let indexPath = indexPath {
//            return fetchResultsController.object(at: indexPath) as? Schema
//        }
//        return nil
//    }
    
}

extension MySchemasListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteringBySearch(searchController.searchBar.text ?? "")
    }
    
    func filteringBySearch(_ searchRequest: String) {
        filteringSchemas = savedSchemas.filter({ schema in
            schema.name.lowercased().contains(searchRequest.lowercased())
        })
        tableView.reloadData()
    }
    
}
