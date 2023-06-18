//
//  Sl_stView.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.06.2023.
//

import UIKit

final class Sl_stView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        Sl_st.drawElement(
            frame: rect,
            resizing: .aspectFit,
            fillColor: UIColor.black
        )
    }
}
