//
//  MySchemasListViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import UIKit

final class MySchemasListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedSchema", for: indexPath)
        
        return cell
    }

}
