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
    
    func save(element: [Element], with name: String) {
        var savedSchema = fetchSavedSchemas()
        let checkValue = check(name: name)
        if checkValue.nameSchema != name {
            savedSchema.append([name: element])
        } else {
            savedSchema[checkValue.index] = [name: element]
        }
        

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
    
    private func check(name: String) -> (nameSchema: String, index: Int, elements: [Element]) {
        let savedSchema = fetchSavedSchemas()
        var duplicateName = ""
        var duplicateNumber = 0
        var editableSchema: [Element] = []
        for (index, schema) in savedSchema.enumerated() {
            for (key, value) in schema {
                if key == name {
                    duplicateName = key
                    duplicateNumber = index
                    editableSchema = value
                }
            }
        }
        return (duplicateName, duplicateNumber, editableSchema)
    }
}
