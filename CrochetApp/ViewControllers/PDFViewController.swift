//
//  PDFViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 28.07.2023.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let fileName = title {
            loadPDFView(fileName)
        }
    }
    
    private func loadPDFView(_ fileName: String) {
        if let path = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            let request = URLRequest(url: path)
            webView.load(request)
        }
    }
}
