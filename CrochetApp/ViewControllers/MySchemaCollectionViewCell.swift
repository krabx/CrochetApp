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
    @IBOutlet var mySchemaImageView: UIImageView!
    
    @IBOutlet var nameOfMySchema: UILabel!
    @IBOutlet var dateOfMySchema: UILabel!
    
    weak var delegate: MySchemaCollectionViewCellDelegate?
    
    private var pdf: PDFDocument = PDFDocument()
    
    private let storageManager = StorageManager.shared
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.delete(item: self)
    }
    
    func configure(for schema: Schema, with indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "dd MMMM YYYY, HH:mm"
        
        nameOfMySchema.text = schema.name
        dateOfMySchema.text = formatter.string(from: schema.date)
        
        setShadowAndCornerRadius()
        loadPDFView(from: schema.image ?? Data())
    }
    
    private func loadPDFView(from data: Data) {
        let pdfDocument = PDFDocument(data: data)?.page(at: 0)
        let pdfSize = pdfDocument?.bounds(for: .mediaBox).size
        let pdfImage = pdfDocument?.thumbnail(of: pdfSize ?? CGSize(), for: .mediaBox)
        mySchemaImageView.image = pdfImage
    }
    
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
