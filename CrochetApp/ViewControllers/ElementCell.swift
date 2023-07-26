//
//  ElementCell.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 20.06.2023.
//

import UIKit

final class ElementCell: UITableViewCell {
    
    func configure(with element: Schema) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.cell()
        
        content.text = element.name
        content.secondaryText = element.date.formatted()
        
        return content
    }

}
