//
//  Symbol.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 11.06.2023.
//

import UIKit

class Symbol: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        ElementOne.drawElement1(
            frame: rect,
            resizing: .aspectFit,
            fillColor: UIColor.black)
    }
}
