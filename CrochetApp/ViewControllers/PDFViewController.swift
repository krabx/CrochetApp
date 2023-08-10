//
//  PDFViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 28.07.2023.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var pdf: PDFDocument = PDFDocument()
    
    var imageViewForPDF = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        loadPDFView()
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func loadPDFView() {
        let pdfView = PDFView(frame: view.bounds)

        view.addSubview(pdfView)

        pdfView.autoScales = true
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + ("\(navigationItem.title ?? fileName).pdf")
//        guard let url = URL(string: documentsURL) else { return }

        //pdfView.document = PDFDocument(url: url)
        pdfView.document = PDFDocument(data: convertImageViewToPDF(imageView: imageViewForPDF))
        pdf = pdfView.document ?? PDFDocument()
        activityIndicator.stopAnimating()
    }
    
    func convertImageViewToPDF(imageView: UIImageView) -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: imageView.bounds)

        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            imageView.layer.render(in: context.cgContext)
        }
        
        return pdfData
    }
}


