//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit

protocol ElementListViewControllerDelegate: AnyObject {
    func getUsage(elements: [Data])
}

final class SchemaViewController: UIViewController {
    
    var resetSelection = false
    var deleteElement = false
    var rotateElement = false
    
    var elementsOnSchema: [Element] = []
    
    let dataManager = DataManager.shared
    
    var elementsData: [Data] = []
    
    @IBOutlet var viewForAddingElementsUIView: UIView!
    @IBOutlet var elementList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementList.delegate = self
        elementList.dataSource = self
        let tap = UITapGestureRecognizer(
            target: self,
            action: !resetSelection ? #selector(touchedScreen(touch:)) : nil
        )
        viewForAddingElementsUIView.addGestureRecognizer(tap)
    }
    
    @IBAction func resetSelectionTableViewButton() {
        resetSelection = true
    }
    
    @IBAction func deleteElementSubView() {
        deleteElement = true
        resetSelection = true
    }
    
    @IBAction func rotateElementSubView() {
        resetSelection = true
        rotateElement = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let elementListVC = navigationVC.topViewController as? ElementListViewController else { return }
        elementListVC.delegate = self
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: viewForAddingElementsUIView)
        
        if !resetSelection {
            guard let newImage = UIImage(data: elementsOnSchema.last?.image ?? Data()) else { return }
            let imageView = UIImageView(frame: CGRect(
                x: touchPoint.x,
                y: touchPoint.y,
                width: 50,
                height: 50)
            )
            imageView.image = newImage
            viewForAddingElementsUIView.addSubview(imageView)
        }
        
        if deleteElement {
            for subView in viewForAddingElementsUIView.subviews {
                if subView.frame.contains(touchPoint) {
                    subView.removeFromSuperview()
                }
            }
        }
        
        if rotateElement {
            for subView in viewForAddingElementsUIView.subviews {
                if subView.frame.contains(touchPoint) {
                    switch subView.transform.a {
                        case 1:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
                        case 0.7071067811865476:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                        case 6.123233995736766e-17:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*3/4)
                        case -0.7071067811865475:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                        case -1:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*5/4)
                        case -0.7071067811865477:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*3/2)
                        case -1.8369701987210297e-16:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*7/4)
                        case 0.7071067811865475:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                        default:
                        subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                    }
                }
            }
        }
    }
    
}

extension SchemaViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elementsData.count == 0 ? 1 : elementsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "elementCell", for: indexPath) as? ElementCell else { return UITableViewCell() }
        if elementsData.count == 0 {
            cell.plug()
        } else {
            cell.configure(with: elementsData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if elementsData.count != 0 {
            elementsOnSchema.append(Element(image: elementsData[indexPath.row]))
        }
    }
}

extension SchemaViewController: ElementListViewControllerDelegate {
    func getUsage(elements: [Data]) {
        for element in elements {
            if elementsData.contains(element) {
                print("Данный элемент уже есть в избранном")
                continue
            } else {
                elementsData.append(element)
            }
        }
        elementList.reloadData()
    }
}
