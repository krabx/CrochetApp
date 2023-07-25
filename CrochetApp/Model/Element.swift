//
//  Element.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 07.06.2023.
//

import Foundation

struct Schema {
    let name: String
    let date: Date
    let element: [Element]
}

struct Element: Codable {
    let x: Double
    let y: Double
    let angle: Double
    let image: Data
}


