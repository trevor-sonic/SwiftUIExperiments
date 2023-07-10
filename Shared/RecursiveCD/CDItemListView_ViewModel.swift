//
//  CDItemListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI
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

// MARK: - ViewModel
extension CDItemListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
        private var moc: NSManagedObjectContext?
        
        
        var model: CDItemListModel? = CDItemListModel()
        
        // MARK: - Bindables
        @Published var items: [Item]
        @Published var selectedItem: Item?
        
        
        @Published var path: NavigationPath = NavigationPath()
        
        
        
        var navigationTitle: String {
            return parentItem?.title ?? "Root"
        }
        
        // MARK: - Relational vars
        var parentItem: Item?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(parentItem: Item? = nil, parentVM: ViewModel? = nil, moc: NSManagedObjectContext?) {
        
            self.items = parentItem?.itemsArray ?? []
            
            self.parentItem = parentItem
            self.parentVM = parentVM
            self.moc = moc
        }
        
        // MARK: - methods
        /// Add item
        func addItem(){
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            print("Add into parent: \(parentItem?.title) in CDItemListView_ViewModel")
            if let model = model {
                items = model.addItem(parentItem: parentItem)
            }
        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.delete( items: items, offsets: offsets)
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            print("⚠️ Implement \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.move( items: items, from: source, to: destination)
            }
        }
    }
}
