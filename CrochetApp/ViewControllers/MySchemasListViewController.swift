//
//  MySchemasListViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import UIKit

final class MySchemasListViewController: UITableViewController {
    private let currentName = ""
    
    private let storageManager = StorageManager.shared
    
    private var savedSchemas: [[String: [Element]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        fetchSchemas()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let schemaVC = segue.destination as? SchemaViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        for (key, value) in savedSchemas[indexPath.row] {
            schemaVC.nameOfSaveSchema = key
            schemaVC.saveElements = value
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSchemas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedSchema", for: indexPath)
        var content = cell.defaultContentConfiguration()
        for savedSchema in savedSchemas[indexPath.row].keys {
            content.text = savedSchema
        }
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let saveSchema = savedSchemas.remove(at: sourceIndexPath.row)
        savedSchemas.insert(saveSchema, at: destinationIndexPath.row)
        storageManager.save(schemas: savedSchemas)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(from: indexPath.row)
            savedSchemas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

extension MySchemasListViewController {
    func fetchSchemas() {
        savedSchemas = storageManager.fetchSavedSchemas()
    }
}
