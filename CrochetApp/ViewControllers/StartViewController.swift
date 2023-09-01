//
//  StartViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.08.2023.
//

import UIKit

final class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "Меню"
        navigationItem.backBarButtonItem = backButton
    }
}
