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
    
    private let storageManager = StorageManager.shared

    //let scrollImageView = UIImageView(image: UIImage(named: "Тестовая схема"))
    
    var resetSelection = false
    var deleteElement = false
    var rotateElement = false
    
    var elementsOnSchema: [Element] = []
    
    let dataManager = DataManager.shared
    
    var elementsData: [Data] = []
    
    @IBOutlet var viewForAddingElementsUIView: UIView!
    @IBOutlet var elementList: UITableView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var schemaImageView: UIImageView!
    
    @IBOutlet var elementsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementList.delegate = self
        elementList.dataSource = self
        elementsCollectionView.dataSource = self
        elementsCollectionView.delegate = self
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(
            target: self,
            action: !resetSelection ? #selector(touchedScreen(touch:)) : nil
        )
        scrollView.addGestureRecognizer(tap)
        //schemaImageView.addGestureRecognizer(tap)
        //viewForAddingElementsUIView.addGestureRecognizer(tap)
        setupScrollView()
    }
    
    @IBAction func deleteElementFromView(_ sender: Any) {
        resetSelection = true
        rotateElement = false
        deleteElement = true
    }
    
    @IBAction func rotateElementOnView(_ sender: Any) {
        resetSelection = true
        rotateElement = true
        deleteElement = false
    }
    @IBAction func saveSchemaOnDevice(_ sender: Any) {
        elementsOnSchema = []
        for subView in schemaImageView.subviews {
            guard let imageView = subView as? UIImageView else { return }
            elementsOnSchema.append(Element(
                x: subView.frame.origin.x,
                y: subView.frame.origin.y,
                angle: subView.transform.a,
                image: imageView.image?.pngData() ?? Data())
            )
        }
        storageManager.save(element: elementsOnSchema)
    }
    
    @IBAction func testButton() {
        for elementOnSchema in elementsOnSchema {
            print("x - \(elementOnSchema.x), y -  \(elementOnSchema.y), angle - \(elementOnSchema.angle), image - \(elementOnSchema.image)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let elementListVC = navigationVC.topViewController as? ElementListViewController else { return }
        elementListVC.delegate = self
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        //let touchPoint = touch.location(in: viewForAddingElementsUIView)
        let touchPoint = touch.location(in: schemaImageView)
        
        if !resetSelection {
            guard let newImage = UIImage(data: elementsData.last ?? Data()) else { return }
            let imageView = UIImageView(frame: CGRect(
                x: touchPoint.x,
                y: touchPoint.y,
                width: 50,
                height: 50)
            )
            imageView.image = newImage
            schemaImageView.addSubview(imageView)
            //viewForAddingElementsUIView.addSubview(imageView)
        }
        
        if deleteElement {
            //for subView in viewForAddingElementsUIView.subviews {
            for subView in schemaImageView.subviews {
                if subView.frame.contains(touchPoint) {
                    subView.removeFromSuperview()
                }
            }
        }
        
        if rotateElement {
            //for subView in viewForAddingElementsUIView.subviews {
            for subView in schemaImageView.subviews {
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
    
    func setupScrollView() {
        //scrollView.addSubview(scrollImageView)
        scrollView.contentSize = schemaImageView.bounds.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.zoomScale = 3
    }
}

extension SchemaViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return schemaImageView
    }
}

extension SchemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elementsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elementImage", for: indexPath) as? ElementCollectionViewCell else { return UICollectionViewCell() }
        //cell.elementImageView.image = UIImage(systemName: "square.and.arrow.up")
        cell.elementImageView.image = UIImage(data: elementsData[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resetSelection = false
        deleteElement = false
        rotateElement = false
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

//        if elementsData.count != 0 {
//            elementsOnSchema.append(Element(image: elementsData[indexPath.row]))
//        }
        
        resetSelection = false
        deleteElement = false
        rotateElement = false
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
        elementsCollectionView.reloadData()
    }
}
