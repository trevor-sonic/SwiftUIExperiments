//
//  Item+CoreDataProperties.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 29/07/2023.
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
    @NSManaged public var position: Int64
    @NSManaged public var title: String //?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: UUID//?
    @NSManaged public var valueDate: Date?
    @NSManaged public var valueDouble: NSNumber?
    @NSManaged public var valueInt: NSNumber?
    @NSManaged public var valueString: String//?
    @NSManaged public var valueType: NSNumber//?
    @NSManaged public var valueArray: String?
    @NSManaged public var valueObject: String //?
    @NSManaged public var parent: Item?
    @NSManaged public var items: Set<Item> // This should be manually added

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
