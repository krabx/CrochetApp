//
//  Element+CoreDataProperties.swift
//  CrochetApp
//
//  Created by Богдан Радченко on 25.07.2023.
//
//

import Foundation
import CoreData


extension Element {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Element> {
        return NSFetchRequest<Element>(entityName: "Element")
    }

    @NSManaged public var angle: Double
    @NSManaged public var image: Data?
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var schema: Schema?

}

extension Element : Identifiable {

}
