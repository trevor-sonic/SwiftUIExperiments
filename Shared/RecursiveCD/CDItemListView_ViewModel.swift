//
//  CDItemListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI
import CoreData



// MARK: - ViewModel
extension CDItemListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
        private var moc: NSManagedObjectContext?
        
        
        var model: CDItemListModel? = CDItemListModel()
        
        // MARK: - Bindables
        @Published var items: [Item] {
            didSet{
                print("items changed items.count: \(String(describing: items.count))")

            }
        }
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
