//
//  TestPanViewController.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.08.2023.
//

import UIKit

class TestPanViewController: UIViewController {
    
    let pan = UIPanGestureRecognizer()

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(touchedScreen(touch:))
        )
        imageView.addGestureRecognizer(tap)
        //imageView.addGestureRecognizer(pan)
       // pan.addTarget(self, action: #selector(handlePan(recognizer:)))
        //imageView.addGestureRecognizer(pan)

        // Do any additional setup after loading the view.
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: imageView)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: imageView)
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: imageView)
        guard let newImage = UIImage(named: "blo") else { return }
        let imageView = UIImageView(frame: CGRect(
            x: touchPoint.x,
            y: touchPoint.y,
            width: 50,
            height: 50)
        )
        imageView.contentMode = .scaleAspectFit
        imageView.image = newImage
        imageView.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(pan)
        self.imageView.addSubview(imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
