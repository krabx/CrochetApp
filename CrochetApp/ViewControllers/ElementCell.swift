//
//  ElementCell.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 20.06.2023.
//

import UIKit

final class ElementCell: UITableViewCell {

    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var elementImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .red
    }
    
    func plug() {
        infoLabel.text = "Add any elements"
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: "System", size: 12)
        infoLabel.layer.opacity = 0.2
    }
    
    func configure(with element: Data) {
        infoLabel.isHidden = true
        elementImageView.image = UIImage(data: element)
    }

}
