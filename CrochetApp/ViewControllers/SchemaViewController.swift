//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit

final class SchemaViewController: UIViewController {
    
    var elementsOnSchema: [Element] = []
    
    let elements = DataManager.shared.elements
    
    var currentElement = UIView()
    
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
//        let renderer = UIGraphicsImageRenderer(size: currentElement.bounds.size)
//        let data = renderer.pngData { ctx in
//            currentElement.drawHierarchy(in: currentElement.bounds, afterScreenUpdates: true)
//        }
        

        
        guard let newImage = UIImage(data: elementsOnSchema.last?.image ?? Data()) else { return }
        
        let imageView = UIImageView(frame: CGRect(
            x: touchPoint.x,
            y: touchPoint.y,
            width: 50,
            height: 50)
        )
        
        imageView.image = newImage
        imageView.layoutIfNeeded()
        //var imageData = newImage.pngData() ?? Data()
        //var element = Element(x: touchPoint.x, y: touchPoint.y, image: imageData)
        //view.addSubview(imageView)
//        newElement.frame.origin = CGPoint(x: touchPoint.x, y: touchPoint.y)
        self.view.addSubview(imageView)
    }

    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //newImage = sender.imageView?.image ?? UIImage()
    }
    
}

extension SchemaViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath)
        let element = elements[indexPath.row]
        let renderer = UIGraphicsImageRenderer(size: element.bounds.size)
        let data = renderer.pngData { ctx in
            element.drawHierarchy(in: element.bounds, afterScreenUpdates: true)
        }
        elementsOnSchema.append(Element(image: data))
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(data: data)
        //elements[indexPath.row].center.x = tableView.frame.width / 2
        //cell.contentView.addSubview(elements[indexPath.row])
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentElement = DataManager.shared.addingOnScreenElements[indexPath.row]
//        let currentElement = DataManager.shared.addingOnScreenElements[indexPath.row]

//        let image = renderer.image { ctx in
//            newElement.drawHierarchy(in: newElement.bounds, afterScreenUpdates: true)
//        }

        //newElement = DataManager.shared.addingOnScreenElements[indexPath.row]
    }
}
