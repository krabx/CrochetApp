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
    

    let elements = [
        ChView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        DcView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        HdcView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        Sl_stView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        TrView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        StartView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    ]
    
    let standard = [
        Sl_stView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        TrView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        StartView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        ChView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        DcView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),
        HdcView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    ]
}
