//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit
import PDFKit

protocol ElementListViewControllerDelegate: AnyObject {
    func getUsage(elements: [Data])
}

final class SchemaViewController: UIViewController {
    
    private let storageManager = StorageManager.shared
    
    private var resetSelection = false
    private var deleteElement = false
    private var rotateElement = false
    
    private var elementsOnSchema: [HelperElementStructure] = []
    
    let dataManager = DataManager.shared
    
    var elementsData: [Data] = []
    
    var nameOfSaveSchema = ""
    
    var saveElements: [Element] = []
    
    private var selectedItem = Data()
    
    private var nameOfSchema = ""
    
    //var schema: Schema = Schema()
    
    @IBOutlet var viewForAddingElementsUIView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var schemaImageView: UIImageView!
    
    @IBOutlet var elementsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        addingSaveElementOnSchema()
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
        
        showAlert(title: "Сохранение", message: "Введите имя схемы") { [unowned self] in
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
            storageManager.checkSchemasFor(name: nameOfSchema, date: date, elementsOnSchema: elementsOnSchema)
        }
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        convertImageViewToPDF(imageView: schemaImageView, fileName: "example")
        performSegue(withIdentifier: "showPDF", sender: nil)
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
            //guard let newImage = UIImage(data: elementsData.last ?? Data()) else { return }
            guard let newImage = UIImage(data: selectedItem) else { return }
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
    
    private func setupScrollView() {
        scrollView.contentSize = schemaImageView.bounds.size
        calculateZoomScale()
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func calculateZoomScale() {
        let boundSize = scrollView.bounds.size
        let imageSize = schemaImageView.bounds.size

        let xScale = boundSize.width / imageSize.width
        let yScale = boundSize.height / imageSize.height

        let minScale = min(xScale, yScale)

        let maxScale: CGFloat = 1

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        
    }
    
        func centerImage() {
            let boundsSize = scrollView.bounds.size
            var frameToCenter = schemaImageView.frame

            if frameToCenter.size.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
            } else {
                frameToCenter.origin.x = 0
            }

            if frameToCenter.size.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
            } else {
                frameToCenter.origin.y = 0
            }

            schemaImageView.frame = frameToCenter
        }
    
    private func addingSaveElementOnSchema() {
        for element in saveElements {
            guard let newImage = UIImage(data: element.image ?? Data()) else { return }
            let imageView = UIImageView(frame: CGRect(
                x: element.x,
                y: element.y,
                width: 50,
                height: 50)
            )
            imageView.image = newImage
            imageView.transform.a = element.angle
            schemaImageView.addSubview(imageView)
        }
    }
}

extension SchemaViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return schemaImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
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
        
        selectedItem = elementsData[indexPath.item]
        
        resetSelection = false
        deleteElement = false
        rotateElement = false
    }
}

extension SchemaViewController {
    func convertImageViewToPDF(imageView: UIImageView, fileName: String) {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: imageView.bounds)
        
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            imageView.layer.render(in: context.cgContext)
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(fileName).pdf")
        
        do {
            try pdfData.write(to: fileURL)
        } catch {
            print("Error creating PDF file: \(error)")
        }
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
    
    private func alertDuplicate() {
        let alert = UIAlertController(title: "Такое имя уже существует", message: "Введите другое название", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
        
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
        elementsCollectionView.reloadData()
    }

}
