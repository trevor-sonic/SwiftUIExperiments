//
//  CDItemListModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 11/07/2023.
//

import Foundation
import CoreData

class CDItemListModel {
    
    
    private var moc = PersistenceController.shared.container.viewContext
    
    
    
    // MARK: - Add
    func addItem(parentItem: Item?, valueType: Item.ValueType? = nil) -> [Item] {
        
        let valueType = valueType ?? .undefined
        switch valueType {

         // add an existing object from original blueprint
        case .object(let objectName):
            guard let objectName = objectName,
                  let masterObject = ItemCRUD().findObject(name: objectName, isMasterObject: true) else {
                break
            }
            
            // create similar object
            _ = ItemCRUD().getItemLike(original: masterObject, parent: parentItem)
           

        default:
            let lastPosition = Int64(parentItem?.itemsAsArray.count ?? 0)
            
            let newItem = ItemCRUD().getNewItem(parent: parentItem)
            newItem.position = lastPosition
            newItem.title = valueType.description
            newItem.valueType = valueType.asNSNumber
            
            
            // Add the same item for the instances of the master object
            syncObjectAdd(parentItem: parentItem, position: lastPosition, valueType: valueType)
            
        }
        
        
        if let parent = parentItem {
            fixPositions(items: parent.itemsAsArray)
            ItemCRUD().save()
            return parent.itemsAsArray
        }
        return []
    }
    // Add, sync other objects from the original
    func syncObjectAdd(parentItem: Item?, position: Int64, valueType: Item.ValueType){
        
        if let parentItem = parentItem,
           let masterObject = findMasterObject(item: parentItem),
           let masterObjectName = masterObject.name {
            
            // pathArray is determining the distance from Object to sub->sub->sub items
            let pathArray = findPathToMasterObject(item: parentItem)

            // find other object instances by name
            let instances = ItemCRUD().findObjects(name: masterObjectName, isMasterObject: false)
            
            // make same changes for each instance
            instances.forEach { instance in
                // Move sub items accordingly with pathArray
                let tmpArray = ItemCRUD().getItems(pathArray: pathArray, fromItem: instance)
                let relativeSubItem = ItemCRUD().getItem(pathArray: pathArray, fromItem: instance)
                
                let newItem = ItemCRUD().getNewItem(parent: relativeSubItem)
                newItem.position = position
                newItem.title = valueType.description
                newItem.valueType = valueType.asNSNumber
                
                
                fixPositions(items: relativeSubItem!.itemsAsArray)
            }
        }
        
    }

    
    
    // Find the Master Object from bottom to top in hierarchy
    func findMasterObject(item: Item, level: Int = 0) -> Item? {
        if item.name == ItemCRUD.rootItemName{
            print("This is not in an Master Object searched \(level) level.")
            return nil
        }
        if item.valueObject == "master" {
            print("Master level\(level): \(String(describing: item.title))")
            return item
        } else {
            if let parent = item.parent{
                
                
                print("Current level\(level): \(String(describing: item.title))")

                return findMasterObject(item: parent, level: level + 1)
            }
        }
        return nil
    }
    
    // Find path to the Master Object from bottom to top in hierarchy
    func findPathToMasterObject(item: Item, pathArray: [String] = [], level: Int = 0) -> [String] {
        
        var tmpArray = pathArray
        
        if item.name == ItemCRUD.rootItemName{
            print("This is not in an Master Object searched \(level) level.")
            return []
        }
        if item.valueObject == "master",
            let name = item.name {
            print("Master level\(level): \(String(describing: item.title))")
            tmpArray.append(name)
            return Array(tmpArray.reversed())
        } else {
            if let parent = item.parent, let name = item.name{
                print("Current level\(level): \(String(describing: item.title))")
                tmpArray.append(name)
                return findPathToMasterObject(item: parent, pathArray: tmpArray, level: level + 1)
            }
        }
        return []
    }
    // MARK: - Delete
    func delete(parentItem: Item?, items: [Item], offsets: IndexSet) -> [Item] {
        
        var tempItems = items
        for index in offsets {
            let item = tempItems[index]
            tempItems.remove(at: index)
            moc.delete(item)
        }
        // delete instances' child items
        syncObjectDelete(parentItem: parentItem, offsets: offsets)
        
        fixPositions(items: tempItems)
        ItemCRUD().save()
        
        return tempItems
        
    }
    func syncObjectDelete(parentItem: Item?, offsets: IndexSet){
        if let parentItem = parentItem,
           let masterObject = findMasterObject(item: parentItem),
           let masterObjectName = masterObject.name {
            
            // pathArray is determining the distance from Object to sub->sub->sub items
            let pathArray = findPathToMasterObject(item: parentItem)

            // find other object instances by name
            let instances = ItemCRUD().findObjects(name: masterObjectName, isMasterObject: false)
            
            // make same changes for each instance
            instances.forEach { instance in
                // Delete sub items accordingly with pathArray
                var items = ItemCRUD().getItems(pathArray: pathArray, fromItem: instance)
                for index in offsets {
                    let item = items[index]
                    items.remove(at: index)
                    moc.delete(item)
                }
                fixPositions(items: items)
            }
        }
    }
    
    // MARK: - Move
    func move(parentItem: Item?, items: [Item], from source: IndexSet, to destination: Int) -> [Item] {
        
        var tempItems = items
        tempItems.move(fromOffsets: source, toOffset: destination)
        fixPositions(items: tempItems)
        
        // Sync other instance of master object
        syncObjectMove(parentItem: parentItem, source: source, destination: destination)

        // finally save
        ItemCRUD().save()
        return tempItems
    }
    // Move other objects from the original
    func syncObjectMove(parentItem: Item?, source: IndexSet, destination: Int){
        
        if let parentItem = parentItem,
           let masterObject = findMasterObject(item: parentItem),
           let masterObjectName = masterObject.name {
            
            // pathArray is determining the distance from Object to sub->sub->sub items
            let pathArray = findPathToMasterObject(item: parentItem)

            // find other object instances by name
            let instances = ItemCRUD().findObjects(name: masterObjectName, isMasterObject: false)
            
            // make same changes for each instance
            instances.forEach { instance in
                // Move sub items accordingly with pathArray
                var tmpArray = ItemCRUD().getItems(pathArray: pathArray, fromItem: instance)
                tmpArray.move(fromOffsets: source, toOffset: destination)
                fixPositions(items: tmpArray)
            }
        }
        
    }
    
    // MARK: - Update
    func update(parentItem: Item?, item: Item, properties: [Item.Property]){
        ItemCRUD().update(item: item, properties: properties)
        
        syncObjectUpdate(item: item, properties: properties)
        
        ItemCRUD().save()
    }
    // Update other objects from the original
    func syncObjectUpdate(item: Item, properties: [Item.Property]){
        
        if let masterObject = findMasterObject(item: item),
           let masterObjectName = masterObject.name {
            
            // pathArray is determining the distance from Object to sub->sub->sub items
            let pathArray = findPathToMasterObject(item: item)

            // find other object instances by name
            let rootInstances = ItemCRUD().findObjects(name: masterObjectName, isMasterObject: false)
            
            // make same changes for each instance
            rootInstances.forEach { instance in
                for property in properties {
                    
                    guard let theItem = ItemCRUD().getItem(pathArray: pathArray, fromItem: instance) else {return}
                    
                    switch property{
                    case .title: theItem.title = item.title
                    case .valueType: theItem.valueType = item.valueType
                    case .valueArray: theItem.valueArray = item.valueArray
                        
                        
                    default: break
                    }
                }
                ItemCRUD().update(item: instance, properties: properties)
            }
        }
        
    }
    // MARK: - Reorder and fix the positions
    private func isPositionsCorrect(items: [Item]) -> Bool {
        if let _ =  items.enumerated().first (where: { (i, item) in
            item.position != i
        }) {
            return false
        }
        return true
    }
    private func fixPositions(items: [Item]){
        guard !isPositionsCorrect(items: items) else {return}
        for i in items.indices {
            
            let oldPos = items[i].positionAsInt
            
            if oldPos != i {
                items[i].position = Int64(i)
                //print("Reordered Item -> \(items[i].position)")
            }
        }
    }
}
