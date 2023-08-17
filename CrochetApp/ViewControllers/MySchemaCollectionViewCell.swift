//
//  MySchemaCollectionViewCell.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 15.08.2023.
//

import UIKit
import PDFKit

final class MySchemaCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet var schemaView: UIView!
    @IBOutlet var mySchemaImageView: UIImageView!
    @IBOutlet var nameOfMySchema: UILabel!
    @IBOutlet var dateOfMySchema: UILabel!
    
    private var pdf: PDFDocument = PDFDocument()
    
    func configure(for schema: Schema) {
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        nameOfMySchema.text = schema.name
        dateOfMySchema.text = schema.date.formatted()
        loadPDFView(from: schema.image ?? Data())
        
//        guard let setElements = schema.elements as? Set<Element> else { return }
//        let elements = Array(setElements)
        
        //setSubviews(of: elements)
    }
    
    private func loadPDFView(from data: Data) {
//        schemaView.autoScales = true
//        schemaView.document = PDFDocument(data: data)
        let pdfDocument = PDFDocument(data: data)?.page(at: 0)
        let pdfSize = pdfDocument?.bounds(for: .mediaBox).size
        let pdfImage = pdfDocument?.thumbnail(of: pdfSize ?? CGSize(), for: .mediaBox)
        mySchemaImageView.image = pdfImage
    }
    
//    private func setSubviews(of elements: [Element]) {
//        for element in elements {
//            guard let newImage = UIImage(data: element.image ?? Data()) else { return }
//            let imageView = UIImageView(frame: CGRect(
//                x: element.x,
//                y: element.y,
//                width: 10,
//                height: 10)
//            )
////            imageView.contentMode = .scaleAspectFit
//            imageView.image = newImage
//            imageView.transform.a = element.angle
//            imageView.transform = CGAffineTransform(rotationAngle: getAngle(imageView) - CGFloat.pi/4)
//            //getAngle(imageView)
//            mySchemaImageView.addSubview(imageView)
//        }
//    }
    
//    private func getAngle(_ subView: UIView) -> CGFloat {
//        var rotationAngle: CGFloat = 0
//        switch subView.transform.a {
//        case 1:
//            rotationAngle = CGFloat.pi/4
//        case 0.7071067811865476:
//            rotationAngle = CGFloat.pi/2
//        case 6.123233995736766e-17:
//            rotationAngle = CGFloat.pi*3/4
//        case -0.7071067811865475:
//            rotationAngle = CGFloat.pi
//        case -1:
//            rotationAngle = CGFloat.pi*5/4
//        case -0.7071067811865477:
//            rotationAngle = CGFloat.pi*3/2
//        case -1.8369701987210297e-16:
//            rotationAngle = CGFloat.pi*7/4
//        case 0.7071067811865475:
//            rotationAngle = CGFloat.pi*2
//        default:
//            rotationAngle = CGFloat.pi*2
//        }
//        return rotationAngle
//    }
}
