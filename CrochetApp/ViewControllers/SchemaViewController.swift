//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit

final class SchemaViewController: UIViewController {
    
    // TODO: - Lost Data in tableView!!!
    
    var elementsOnSchema: [Element] = []
    
    let dataManager = DataManager.shared
    
    var elementsData: [Data] = []
    
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
        rendererViewToData()
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        guard let newImage = UIImage(data: elementsOnSchema.last?.image ?? Data()) else { return }
        let imageView = UIImageView(frame: CGRect(
            x: touchPoint.x,
            y: touchPoint.y,
            width: 50,
            height: 50)
        )
        imageView.image = newImage
        //imageView.layoutIfNeeded()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath) as? ElementCell else { return UITableViewCell() }
        cell.elementImageView.image = UIImage(data: elementsData[indexPath.row])
//        elements[indexPath.row].center.x = tableView.frame.width / 2
//        cell.contentView.addSubview(elements[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elementsOnSchema.append(Element(image: elementsData[indexPath.row]))
    }
}

//extension UIImage{
//    convenience init(view: UIView) {
//
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    self.init(cgImage: (image?.cgImage)!)
//
//  }
//}

extension SchemaViewController {
    private func rendererViewToData() {
        let elements = dataManager.elements

        for element in elements {
            let renderer = UIGraphicsImageRenderer(size: element.bounds.size)
            let data = renderer.pngData { ctx in
                element.drawHierarchy(in: element.bounds, afterScreenUpdates: true)
            }
            
            elementsData.append(data)
        }
    }
}
