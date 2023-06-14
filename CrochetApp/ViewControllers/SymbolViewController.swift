//
//  SymbolViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 11.06.2023.
//

import UIKit

class SymbolViewController: UIViewController {
    let symbol = Symbol(frame: CGRect.init(
        x: 0,
        y: 200,
        width: 70,
        height: 70)
    )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbol.center.x = self.view.frame.width / 2
        self.view.addSubview(symbol)
    }
}
