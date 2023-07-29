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
            
            let newItem = ItemCRUD().getItemLike(original: masterObject, parent: parentItem)
           

        default: //.string, .int, .double, .date:
            let newItem = ItemCRUD().getNewItem(parent: parentItem)
            newItem.position = 0
            newItem.title = valueType.description
            newItem.valueType = valueType.asNSNumber
            
            if let parentItem = parentItem {
                syncObjectAdd(parentItem: parentItem)
            }
        }
        
        
        if let parent = parentItem {
            fixPositions(items: parent.itemsAsArray)
            ItemCRUD().save()
            return parent.itemsAsArray
        }
        return []
    }
    // MARK: - Sync other objects from the original
    func syncObjectAdd(parentItem: Item){
        
        // find the master object
        if let masterObject = findMasterObject(item: parentItem) {
            print("masterObject name: \(String(describing: masterObject.name))")
            let instances = ItemCRUD().findObjects(isMasterObject: false)
            print("instances count: \(String(describing: instances.count))")
        }
        
    }
    func syncObjectMove(parentItem: Item){
        
        // find the master object
        if let masterObject = findMasterObject(item: parentItem) {
            print("masterObject name: \(String(describing: masterObject.name))")
            let instances = ItemCRUD().findObjects(isMasterObject: false)
            print("instances count: \(String(describing: instances.count))")
        }
        
//        var tempItems = items
//        tempItems.move(fromOffsets: source, toOffset: destination)
//
//        fixPositions(items: tempItems)
//        ItemCRUD().save()
        
    }
    // Find the Master Object from bottom to top in hierarchy
    func findMasterObject(item: Item, level: Int = 0) -> Item? {
        if item.name == ItemCRUD.rootItemName{
            print("This is not in an Master Object searched \(level) level.")
            return nil
        }
        if item.valueObject == "master" {
            print("master found at level: \(level)")
            return item
        } else {
            if let parent = item.parent{
                return findMasterObject(item: parent, level: level + 1)
            }
        }
        return nil
    }
    // MARK: - Delete
    func delete(items: [Item], offsets: IndexSet) -> [Item] {
        
        var tempItems = items
        for index in offsets {
            let item = tempItems[index]
            tempItems.remove(at: index)
            moc.delete(item)
        }
        fixPositions(items: tempItems)
        ItemCRUD().save()
        
        return tempItems
        
    }
    // MARK: - Move
    func move(parentItem: Item?, items: [Item], from source: IndexSet, to destination: Int) -> [Item] {
        
        var tempItems = items
        tempItems.move(fromOffsets: source, toOffset: destination)

        fixPositions(items: tempItems)
        ItemCRUD().save()
        
        return tempItems
    }
    
    // MARK: - Update
    func update(item: Item){
        ItemCRUD().update(item: item)
        ItemCRUD().save()
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
                print("Reordered Item -> \(items[i].position)")
            }
        }
    }
}
