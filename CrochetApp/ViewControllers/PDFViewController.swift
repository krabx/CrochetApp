//
//  PDFViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 28.07.2023.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {
    
    private var pdf: PDFDocument = PDFDocument()

    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationItem.title == "" {
            navigationItem.title = "example"
        }
        loadPDFView("example")
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func loadPDFView(_ fileName: String) {
        let pdfView = PDFView(frame: view.bounds)

        self.view.addSubview(pdfView)

        pdfView.autoScales = true

        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + ("\(navigationItem.title ?? fileName).pdf")
        guard let url = URL(string: documentsURL) else { return }

        pdfView.document = PDFDocument(url: url)
        let pdf = pdfView.document
    }


}


