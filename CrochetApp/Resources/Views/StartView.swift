//
//  StartView.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.06.2023.
//

import UIKit

class StartView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        Start.drawElement(frame: rect, resizing: .aspectFit, fillColor: UIColor.black)
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
