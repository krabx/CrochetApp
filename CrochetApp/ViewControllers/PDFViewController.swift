//
//  PDFViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 28.07.2023.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationItem.title == "" {
            navigationItem.title = "example"
        }
        loadPDFView("example")
    }

    private func loadPDFView(_ fileName: String) {
        let pdfView = PDFView(frame: view.bounds)

        self.view.addSubview(pdfView)

        pdfView.autoScales = true

        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString + ("\(navigationItem.title ?? fileName).pdf")
        guard let url = URL(string: documentsURL) else { return }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        print(documentsURL)
        pdfView.document = PDFDocument(url: url)
    }


}


