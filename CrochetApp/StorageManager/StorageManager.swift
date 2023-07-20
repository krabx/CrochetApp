//
//  StorageManager.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let key = "savedSchema"
    
    private init() {}
    
    func save(element: [Element]) {
        var savedSchema = fetchSavedSchemas()
        savedSchema.append(element)
        
        guard let data = try? JSONEncoder().encode(savedSchema) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchSavedSchemas() -> [[Element]] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let savedSchema = try? JSONDecoder().decode([[Element]].self, from: data) else {
            print("error from fetch saved schema")
            return []
        }
        return savedSchema
    }
}
