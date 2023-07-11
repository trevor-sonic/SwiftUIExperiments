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
    func addItem(parentItem: Item?) -> [Item] {
        let newItem = ItemCRUD().getNewItem(parent: parentItem)
        newItem.title = "New Item \((10...99).randomElement()!)"
        newItem.position = 0
        
        if let parent = parentItem {
            fixPositions(items: parent.itemsArray)
            ItemCRUD().save()
            return parent.itemsArray
        }
        return []
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
    func move(items: [Item], from source: IndexSet, to destination: Int) -> [Item] {
        
        var tempItems = items
        tempItems.move(fromOffsets: source, toOffset: destination)

        fixPositions(items: tempItems)
        ItemCRUD().save()
        
        return tempItems
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
