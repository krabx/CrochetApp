//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit

final class SchemaViewController: UIViewController {
    
    let symbol = Symbol(frame: CGRect.init(
        x: 0,
        y: 0,
        width: 100,
        height: 100)
    )
    
    var newElement = UIView()
    
    @IBOutlet var elementList: UITableView!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementList.delegate = self
        elementList.dataSource = self
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(touchedScreen(touch:))
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
//        let symbol = Symbol(frame: CGRect.init(
//            x: touchPoint.x,
//            y: touchPoint.y,
//            width: 100,
//            height: 100)
//        )
//        let imageView = UIImageView(frame: CGRect(
//            x: touchPoint.x,
//            y: touchPoint.y,
//            width: newImage.size.width,
//            height: newImage.size.height)
//        )
        //imageView.image = newImage
        //var imageData = newImage.pngData() ?? Data()
        //var element = Element(x: touchPoint.x, y: touchPoint.y, image: imageData)
        //view.addSubview(imageView)
        view.addSubview(newElement)
    }

    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //newImage = sender.imageView?.image ?? UIImage()
    }
    
}

extension SchemaViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath)
        cell.contentView.addSubview(symbol)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newElement = symbol
    }
    
    
}
