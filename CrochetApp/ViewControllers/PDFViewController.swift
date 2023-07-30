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
        loadPDFView("example")
    }
    
    private func loadPDFView(_ fileName: String) {
//        guard let url = Bundle.main.url(forResource: fileName, withExtension: ".pdf") else { return }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appending(path: ("\(fileName).pdf"))
        let request = URLRequest(url: fileURL)
        webView.load(request)
        
    }
    
}
