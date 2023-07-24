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
    
    func save(element: [String: [Element]]) {
        var savedSchema = fetchSavedSchemas()
        savedSchema.append(element)
        
        guard let data = try? JSONEncoder().encode(savedSchema) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchSavedSchemas() -> [[String: [Element]]] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let savedSchema = try? JSONDecoder().decode([[String: [Element]]].self, from: data) else {
            print("error from fetch saved schema")
            return []
        }
        return savedSchema
    }
    
    func delete() {
        userDefaults.removeObject(forKey: key)
    }
    
    func check(name: String) -> String {
        let savedSchema = fetchSavedSchemas()
        var duplicateName = ""
        for schema in savedSchema {
            for key in schema.keys {
                if key == name {
                    duplicateName = name
                }
            }
        }
        return duplicateName
    }
}
