//
//  StorageManager.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 21.07.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    //private let userDefaults = UserDefaults.standard
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SchemaCoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //private let key = "savedSchema"
    
    private init() {}
    
//    func fetchedResultController(entityName: String) -> NSFetchedResultsController<NSFetchRequestResult> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        var sortDescriptors: [NSSortDescriptor] = []
//        let sortDescription: NSSortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
//        sortDescriptors.append(sortDescription)
//        fetchRequest.sortDescriptors = sortDescriptors
//        
//        let fetchResultController = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: viewContext,
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//        
//        return fetchResultController
//    }
    
    func appendWith(name: String, date: Date, elementsOnSchema: [HelperElementStructure]) {
        
        let schema = Schema(context: viewContext)
        schema.name = name
        schema.date = date
        for elementOnSchema in elementsOnSchema {
            let addingElement = Element(context: viewContext)
            addingElement.x = elementOnSchema.x
            addingElement.y = elementOnSchema.y
            addingElement.angle = elementOnSchema.angle
            addingElement.image = elementOnSchema.image
            schema.addToElements(addingElement)
        }
        saveContext()
    }
    
//    func fetchSchemas(completion: (Result<[Schema], Error>) -> Void) {
//        let fetchRequest = Schema.fetchRequest()
//
//        do {
//            let schemas = try viewContext.fetch(fetchRequest)
//            completion(.success(schemas))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
    
    func fetchSchemas(completion: (Result<[Schema], Error>) -> Void) {
        let fetchRequest = Schema.fetchRequest()
        do {
            let schemas = try viewContext.fetch(fetchRequest)
            completion(.success(schemas))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(schema: Schema) {
        viewContext.delete(schema)
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func append(element: [Element], with name: String) {
//        var savedSchema = fetchSavedSchemas()
//        let checkValue = check(name: name)
//        if checkValue.nameSchema != name {
//            savedSchema.append([name: element])
//        } else {
//            savedSchema[checkValue.index] = [name: element]
//        }
//
//
//        guard let data = try? JSONEncoder().encode(savedSchema) else { return }
//        userDefaults.set(data, forKey: key)
//    }
//
//    func save(schemas: [[String: [Element]]]) {
//        var savedSchemas = fetchSavedSchemas()
//        savedSchemas.removeAll()
//
//        guard let data = try? JSONEncoder().encode(schemas) else { return }
//        userDefaults.set(data, forKey: key)
//    }
//
//    func delete(from index: Int) {
//        var savedSchemas = fetchSavedSchemas()
//        savedSchemas.remove(at: index)
//
//        guard let data = try? JSONEncoder().encode(savedSchemas) else { return }
//        userDefaults.set(data, forKey: key)
//    }
//
//    func fetchSavedSchemas() -> [[String: [Element]]] {
//        guard let data = userDefaults.data(forKey: key) else { return [] }
//        guard let savedSchema = try? JSONDecoder().decode([[String: [Element]]].self, from: data) else {
//            print("error from fetch saved schema")
//            return []
//        }
//        return savedSchema
//    }
//
//    func delete() {
//        userDefaults.removeObject(forKey: key)
//    }
//
//    private func check(name: String) -> (nameSchema: String, index: Int, elements: [Element]) {
//        let savedSchema = fetchSavedSchemas()
//        var duplicateName = ""
//        var duplicateNumber = 0
//        var editableSchema: [Element] = []
//        for (index, schema) in savedSchema.enumerated() {
//            for (key, value) in schema {
//                if key == name {
//                    duplicateName = key
//                    duplicateNumber = index
//                    editableSchema = value
//                }
//            }
//        }
//        return (duplicateName, duplicateNumber, editableSchema)
//    }
}
