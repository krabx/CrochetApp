//
//  Schema+CoreDataProperties.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 25.07.2023.
//
//

import Foundation
import CoreData


extension Schema {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schema> {
        return NSFetchRequest<Schema>(entityName: "Schema")
    }

    @NSManaged public var date: Date
    @NSManaged public var image: Data?
    @NSManaged public var name: String
    @NSManaged public var elements: NSSet?

}

// MARK: Generated accessors for elements
extension Schema {

    @objc(addElementsObject:)
    @NSManaged public func addToElements(_ value: Element)

    @objc(removeElementsObject:)
    @NSManaged public func removeFromElements(_ value: Element)

    @objc(addElements:)
    @NSManaged public func addToElements(_ values: NSSet)

    @objc(removeElements:)
    @NSManaged public func removeFromElements(_ values: NSSet)

}

extension Schema : Identifiable {

}
