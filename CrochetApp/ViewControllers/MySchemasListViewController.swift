//
//  MySchemasListViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import UIKit

final class MySchemasListViewController: UITableViewController {
    private let storageManager = StorageManager.shared
    
    private var savedSchemas: [[String: [Element]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchemas()
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

        return cell
    }

}

extension MySchemasListViewController {
    func fetchSchemas() {
        savedSchemas = storageManager.fetchSavedSchemas()
    }
}
