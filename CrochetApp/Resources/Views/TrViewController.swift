//
//  TrViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.06.2023.
//

import UIKit

class TrViewController: UIViewController {
    //let trView = DataManager.shared.elements[0]
    let trView = StartView(frame: CGRect(x: 0, y: 70, width: 199, height: 199))

    override func viewDidLoad() {
        super.viewDidLoad()
        trView.center.x = self.view.frame.width / 2
        self.view.addSubview(trView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
