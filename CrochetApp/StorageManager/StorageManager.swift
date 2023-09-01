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
    
    private init() {}
    
    func appendWith(name: String, date: Date, elementsOnSchema: [HelperElementStructure], image: Data, backgroundImageIndex: Int) {
        
        let schema = Schema(context: viewContext)
        schema.name = name
        schema.date = date
        schema.image = image
        schema.backgroundImageIndex = Double(backgroundImageIndex)
        
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
                let NSError = error as NSError
                fatalError("Unresolved error \(NSError), \(NSError.userInfo)")
            }
        }
    }
    
    func checkSchemasFor(name: String, date: Date, elementsOnSchema: [HelperElementStructure], image: Data, backgroundImageIndex: Int) {
        var savedSchema: [Schema] = []
        
        fetchSchemas { result in
            switch result {
            case .success(let schemas):
                savedSchema = schemas
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        for schema in savedSchema {
            if schema.name == name {
                delete(schema: schema)
            }
        }
        
        appendWith(name: name, date: date, elementsOnSchema: elementsOnSchema, image: image, backgroundImageIndex: backgroundImageIndex)
        
        saveContext()
    }
}
