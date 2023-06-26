//
//  Item+CoreDataProperties.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var position: Int64
    @NSManaged public var items: Set<Item>

}

// MARK: Generated accessors for items
extension Item {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Item : Identifiable {

}
