//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit
import PDFKit

protocol ElementCollectionViewControllerDelegate: AnyObject {
    func getUsage(elements: [String])
}

final class SchemaViewController: UIViewController {
    
    private let storageManager = StorageManager.shared
    
    private var resetSelection = false
    private var deleteElement = false
    private var rotateElement = false
    
    private var elementsOnSchema: [HelperElementStructure] = []
    
    let dataManager = DataManager.shared
    
    var elementsData: [String] = []
    
    var nameOfSaveSchema = ""
    
    var saveElements: [Element] = []
    
    private var selectedItem: String = ""
    
    private var nameOfSchema = ""
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var schemaImageView: UIImageView!
    
    @IBOutlet var elementsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segment: UISegmentedControl = UISegmentedControl(items: ["1","2"])
        
        setupFor(segment)

        navigationItem.titleView = segment
        
        let backButton = UIBarButtonItem()
        
        backButton.title = "Назад"
        
        navigationItem.backBarButtonItem = backButton
        
        let rotateAction = UIAction(title: "Режим поворота", image: UIImage(systemName: "rotate.right")) { [unowned self] _ in
            self.resetSelection = true
            self.rotateElement = true
            self.deleteElement = false
            for subview in schemaImageView.subviews {
                subview.layer.borderWidth = 1
            }
        }
        
        let deleteAction = UIAction(title: "Режим удаления", image: UIImage(systemName: "trash")) { [unowned self] _ in
            self.resetSelection = true
            self.rotateElement = false
            self.deleteElement = true
            for subview in schemaImageView.subviews {
                subview.layer.borderWidth = 1
            }
        }
        
        let saveSchemaAction = UIAction(title: "Сохранить схему", image: UIImage(systemName: "square.and.arrow.down")) { [unowned self] _ in
            showAlert(title: "Сохранение", message: "Введите имя схемы") {
                self.elementsOnSchema = []
                    for subView in self.schemaImageView.subviews {
                        guard let imageView = subView as? UIImageView else { return }
                        self.elementsOnSchema.append(HelperElementStructure(
                            x: subView.frame.origin.x,
                            y: subView.frame.origin.y,
                            angle: subView.transform.a,
                            image: imageView.image?.pngData() ?? Data())
                        )
                    }
                let date = Date.now
                self.storageManager.checkSchemasFor(name: self.nameOfSchema, date: date, elementsOnSchema: self.elementsOnSchema, image: self.convertImageViewToPDF(imageView: self.schemaImageView))
            }
        }
        
        let addFavoriteElement = UIAction(title: "Добавить элемент в избранное", image: UIImage(systemName: "plus")) { [unowned self] _ in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let elementCollectionVC = storyBoard.instantiateViewController(identifier: "ElementCollectionVC") as? ElementCollectionViewController else { return }
            elementCollectionVC.delegate = self
            show(elementCollectionVC, sender: nil)
            
            //present(elementListVC, animated: true)
        }
        
        let showPDF = UIAction(title: "Показать PDF", image:UIImage(systemName: "doc")) { [unowned self] _ in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let showPDFVC = storyBoard.instantiateViewController(identifier: "showPDF") as? PDFViewController else { return }
            showPDFVC.imageViewForPDF = schemaImageView
            show(showPDFVC, sender: nil)
        }
        
        let menu = UIMenu(title: "Меню", children: [rotateAction, deleteAction, saveSchemaAction, addFavoriteElement, showPDF])
        
        let barMenuButton = UIBarButtonItem(title: "Меню", image: UIImage(systemName: "list.bullet"), menu: menu)
        
        navigationItem.rightBarButtonItem = barMenuButton

        elementsCollectionView.dataSource = self
        elementsCollectionView.delegate = self
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(
            target: self,
            action: !resetSelection ? #selector(touchedScreen(touch:)) : nil
        )
        scrollView.addGestureRecognizer(tap)
        setupScrollView()
        addingSaveElementOnSchema()
    }
    
    func convertImageViewToPDF(imageView: UIImageView) -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: imageView.bounds)

        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            imageView.layer.render(in: context.cgContext)
        }
        
        return pdfData
    }
    
//    private func getAngle(_ subView: UIView) {
//        switch subView.transform.a {
//        case 1:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
//        case 0.7071067811865476:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
//        case 6.123233995736766e-17:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*3/4)
//        case -0.7071067811865475:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        case -1:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*5/4)
//        case -0.7071067811865477:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*3/2)
//        case -1.8369701987210297e-16:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*7/4)
//        case 0.7071067811865475:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
//        default:
//            subView.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
//        }
//    }
    
    private func getAngle(_ subView: UIView) -> CGFloat {
        var rotationAngle: CGFloat = 0
        switch subView.transform.a {
        case 1:
            rotationAngle = CGFloat.pi/4
        case 0.7071067811865476:
            rotationAngle = CGFloat.pi/2
        case 6.123233995736766e-17:
            rotationAngle = CGFloat.pi*3/4
        case -0.7071067811865475:
            rotationAngle = CGFloat.pi
        case -1:
            rotationAngle = CGFloat.pi*5/4
        case -0.7071067811865477:
            rotationAngle = CGFloat.pi*3/2
        case -1.8369701987210297e-16:
            rotationAngle = CGFloat.pi*7/4
        case 0.7071067811865475:
            rotationAngle = CGFloat.pi*2
        default:
            rotationAngle = CGFloat.pi*2
        }
        return rotationAngle
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: schemaImageView)
        if !resetSelection {
            // -TODO: think about it
            for subview in schemaImageView.subviews {
                subview.layer.borderWidth = 0
            }
            if selectedItem != "" {
                guard let newImage = UIImage(named: selectedItem) else { return }
                let imageView = UIImageView(frame: CGRect(
                    x: touchPoint.x,
                    y: touchPoint.y,
                    width: 50,
                    height: 50)
                )
                imageView.contentMode = .scaleAspectFit
                imageView.image = newImage
                schemaImageView.addSubview(imageView)
            }
        }
        
        if deleteElement {
            for subView in schemaImageView.subviews {
                if subView.frame.contains(touchPoint) {
                    subView.removeFromSuperview()
                }
            }
        }
        
        if rotateElement {
            for subView in schemaImageView.subviews {
                if subView.frame.contains(touchPoint) {
                    subView.transform = CGAffineTransform(rotationAngle: getAngle(subView))
                }
            }
        }
    }
    
    private func setupScrollView() {
        scrollView.contentSize = schemaImageView.bounds.size
        calculateZoomScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func calculateZoomScale() {
        let boundSize = scrollView.bounds.size
        let imageSize = schemaImageView.bounds.size

        let xScale = boundSize.width / imageSize.width
        let yScale = boundSize.height / imageSize.height

        let minScale = min(xScale, yScale)

        let maxScale: CGFloat = 2

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        
    }
    
//    func centerImage() {
//        let boundsSize = scrollView.bounds.size
//        var frameToCenter = schemaImageView.frame
//
//        if frameToCenter.size.width < boundsSize.width {
//            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
//        } else {
//            frameToCenter.origin.x = 0
//        }
//
//        if frameToCenter.size.height < boundsSize.height {
//            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
//        } else {
//            frameToCenter.origin.y = 0
//        }
//
//        schemaImageView.frame = frameToCenter
//    }
    
    private func addingSaveElementOnSchema() {
        for element in saveElements {
            guard let newImage = UIImage(data: element.image ?? Data()) else { return }
            let imageView = UIImageView(frame: CGRect(
                x: element.x,
                y: element.y,
                width: 50,
                height: 50)
            )
            imageView.contentMode = .scaleAspectFit
            imageView.image = newImage
            imageView.transform.a = element.angle
            imageView.transform = CGAffineTransform(rotationAngle: getAngle(imageView) - CGFloat.pi/4)
            //getAngle(imageView)
            schemaImageView.addSubview(imageView)
        }
    }
}

extension SchemaViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return schemaImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //centerImage()
    }
}

extension SchemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elementsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elementImage", for: indexPath) as? ElementCollectionViewCell else { return UICollectionViewCell() }
        
        cell.elementImageView.image = UIImage(named: elementsData[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem = elementsData[indexPath.item]
        
        resetSelection = false
        deleteElement = false
        rotateElement = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension SchemaViewController {
    private func showAlert(title: String, message: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField {[unowned self] textField in
            if self.nameOfSaveSchema != "" {
                textField.text = nameOfSaveSchema
            }
        }
        let okButton = UIAlertAction(title: "Ок", style: .default) { _ in
            if let name = alert.textFields?.first?.text {
                self.nameOfSchema = name
                completionHandler()
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    private func setupFor(_ segment: UISegmentedControl) {
        let squareBackground = UIAction(image: UIImage(systemName: "grid")) { [unowned self] _ in
            self.schemaImageView.image = UIImage(named: "сетка квадрат точка ")
        }
        
        let circleBackground = UIAction(image: UIImage(systemName: "circle.circle")) { [unowned self] _ in
            self.schemaImageView.image = UIImage(named: "сетка точка 20 круг")
        }
        
        segment.selectedSegmentIndex = 1
        
        segment.setAction(squareBackground, forSegmentAt: 0)
        segment.setAction(circleBackground, forSegmentAt: 1)
    }
}

extension SchemaViewController: ElementCollectionViewControllerDelegate {
    func getUsage(elements: [String]) {
        for element in elements {
            if elementsData.contains(element) {
                print("Данный элемент уже есть в избранном")
                continue
            } else {
                elementsData.append(element)
            }
        }
        elementsCollectionView.reloadData()
    }
}
