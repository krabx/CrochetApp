//
//  MySchemaCollectionViewCell.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 15.08.2023.
//

import UIKit
import PDFKit

protocol MySchemaCollectionViewCellDelegate: AnyObject {
    func delete(item: MySchemaCollectionViewCell)
}

final class MySchemaCollectionViewCell: UICollectionViewCell {
    
    private let storageManager = StorageManager.shared
    
    weak var delegate: MySchemaCollectionViewCellDelegate?
    
//    @IBOutlet var schemaView: UIView!
    @IBOutlet var mySchemaImageView: UIImageView!
    @IBOutlet var nameOfMySchema: UILabel!
    @IBOutlet var dateOfMySchema: UILabel!
    
    private var pdf: PDFDocument = PDFDocument()
    
    let deleteButton = UIButton()
    
    func configure(for schema: Schema, with indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "dd MMMM YYYY, HH:mm"
        
        nameOfMySchema.text = schema.name
        dateOfMySchema.text = formatter.string(from: schema.date)
        
        setShadowAndCornerRadius()
        loadPDFView(from: schema.image ?? Data())
//        setDeleteButton(schema, indexPath)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.delete(item: self)
    }
    private func loadPDFView(from data: Data) {
//        schemaView.autoScales = true
//        schemaView.document = PDFDocument(data: data)
        let pdfDocument = PDFDocument(data: data)?.page(at: 0)
        let pdfSize = pdfDocument?.bounds(for: .mediaBox).size
        let pdfImage = pdfDocument?.thumbnail(of: pdfSize ?? CGSize(), for: .mediaBox)
        mySchemaImageView.image = pdfImage
    }
    
//    private func setDeleteButton(_ schema: Schema, _ indexPath: IndexPath) {
//        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
//        deleteButton.tintColor = .red
//        self.addSubview(deleteButton)
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
//        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
//
//
//        let deleteAction = UIAction { [unowned self] _ in
//            delegate?.updateCollection(with: indexPath)
//        }
//
//        deleteButton.addAction(deleteAction, for: .touchUpInside)
//    }
    
    private func setShadowAndCornerRadius() {
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
    }
}
