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
    
    var imageViewForPDF: UIImageView!
    
    private var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        loadPDFView()
        guard let filePath = Bundle.main.path(forResource: "example", ofType: "pdf") else { return }
                
        pdfURL = URL(fileURLWithPath: filePath)

    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    private func loadPDFView() {
        let pdfView = PDFView(frame: view.bounds)
        
        view.addSubview(pdfView)

        pdfView.document = PDFDocument(data: convertImageViewToPDF(imageView: imageViewForPDF))
        
        pdfView.autoScales = true
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let pdfURL = documentsURL.appendingPathComponent("example.pdf")
        
        pdfView.document?.write(to: pdfURL)
        print(pdfURL)

        activityIndicator.stopAnimating()
    }
    
    private func convertImageViewToPDF(imageView: UIImageView) -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: imageView.bounds)
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            imageView.layer.render(in: context.cgContext)
        }
        
        return pdfData
    }
}


