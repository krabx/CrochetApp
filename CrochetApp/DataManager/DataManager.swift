//
//  DataManager.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 18.06.2023.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    let categories = [
        "Основные",
        "Столбик без накида (СБН)",
        "Полустолбик с накидом (ПСН)",
        "Столбик с накидом (ССН)",
        "Столбик с 2 накидами (СС2Н)",
        "Столбик с 3 накидами (СС3Н)",
        "Столбик с 4 накидами (СС4Н)",
        "Столбик с 5 накидами (СС5Н)",
        "Рельеф",
        "Другое"
    ]
    
    let main = [
        "start",
        "end",
        "cs",
        "ss",
        "magic_ring",
        "blo",
        "flo",
        "ch_3_picot",
        "ch_5_picot"
    ]
    
    let singleCrochet = [
        "sc"
    ]
    
    let halfDoubleCrochet = [
        "hdc"
    ]
    
    let doubleCrochet = [
        "dc"
    ]
    
    let columnWithTwoCrochets = [
        "tr"
    ]
    
    let columnWithThreeCrochets = [
        "dtr"
    ]
    
    let columnWithFourCrochets = [
        "trtr"
    ]
    
    let columnWithFiveCrochets = [
        "dtrtr"
    ]
    
    let relief = [
        "BPsc",
        "FPsc",
        "BPhdc",
        "FPhdc",
        "BPdc",
        "FPdc",
        "BPtr",
        "FPtr",
        "BPdtr",
        "FPdtr",
        "BPtrtr",
        "FPtrtr",
        "BPdtrtr",
        "FPdtrtr"
    ]
    
    let other: [String] = []
    
    func getCount(for category: String) -> Int {
        switch category {
        case "Oсновные":
             return main.count
        case "Столбик без накида (СБН)":
            return singleCrochet.count
        case "Полустолбик с накидом (ПСН)":
            return halfDoubleCrochet.count
        case "Столбик с накидом (ССН)":
            return doubleCrochet.count
        case "Столбик с 2 накидами (СС2Н)":
            return columnWithTwoCrochets.count
        case "Столбик с 3 накидами (СС2Н)":
            return columnWithThreeCrochets.count
        case "Столбик с 4 накидами (СС2Н)":
            return columnWithFourCrochets.count
        case "Столбик с 5 накидами (СС2Н)":
            return columnWithFiveCrochets.count
        case "Рельеф":
            return relief.count
        default:
            return other.count
        }
    }
    
    func getCountCollection(from number: Int) -> Int {
        let counts = [
            main.count,
            singleCrochet.count,
            halfDoubleCrochet.count,
            doubleCrochet.count,
            columnWithTwoCrochets.count,
            columnWithThreeCrochets.count,
            columnWithFourCrochets.count,
            columnWithFiveCrochets.count,
            relief.count,
            other.count
        ]
        
        return counts[number]
    }
    
    func getCollection(from number: Int) -> [String] {
        let allSets = [
            main,
            singleCrochet,
            halfDoubleCrochet,
            doubleCrochet,
            columnWithTwoCrochets,
            columnWithThreeCrochets,
            columnWithFourCrochets,
            columnWithFiveCrochets,
            relief,
            other
        ]
        
        return allSets[number]
    }
}
