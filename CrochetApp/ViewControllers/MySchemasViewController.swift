//
//  MySchemasViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 08.07.2023.
//

import UIKit

class MySchemasViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 5
        scrollView.contentSize = imageView.bounds.size
        //scrollView.zoomScale = scrollView.minimumZoomScale
    }

}

extension MySchemasViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}
