//
//  ChView.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.06.2023.
//

import UIKit

final class ChView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        Ch.drawElement(
            frame: rect,
            resizing: .aspectFit,
            fillColor: UIColor.black
        )
    }
}
