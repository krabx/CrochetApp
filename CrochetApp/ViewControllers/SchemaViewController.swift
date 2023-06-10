//
//  SchemaViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import UIKit

final class SchemaViewController: UIViewController {
    var newImage = UIImage()

    
    @IBOutlet var buttons: [UIButton]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(touchedScreen(touch:))
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let imageView = UIImageView(frame: CGRect(
            x: touchPoint.x,
            y: touchPoint.y,
            width: newImage.size.width,
            height: newImage.size.height)
        )
        imageView.image = newImage
        //var imageData = newImage.pngData() ?? Data()
        //var element = Element(x: touchPoint.x, y: touchPoint.y, image: imageData)
        view.addSubview(imageView)
    }

    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        newImage = sender.imageView?.image ?? UIImage()
    }
    
}

