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
