//
//  CDItemListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI



// MARK: - ViewModel
extension CDItemListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
        
        var model: CDItemListModel? = CDItemListModel()
        
        // MARK: - Bindables
        @Published var items: [Item]
        @Published var selectedItem: Item?
        @Published var path: NavigationPath = NavigationPath()
        
        // sub vm
        @Published var detailsVM: CDItemDetailsView.ViewModel
        
        var navigationTitle: String {
            return parentItem?.title ?? "Root"
        }
        
        // MARK: - Relational vars
        var parentItem: Item?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(parentItem: Item? = nil, parentVM: ViewModel? = nil){
        
            self.items = parentItem?.itemsArray ?? []
            self.parentVM = parentVM
            self.parentItem = parentItem
            
            
            detailsVM = CDItemDetailsView.ViewModel(item: parentItem)
        }
        
        // MARK: - methods
        /// Add item
        func addItem(){
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            print("Add into parent: \(parentItem?.title) in CDItemListView_ViewModel")
            if let model = model {
                items = model.addItem(parentItem: parentItem)
                detailsVM.items = items
                
            }
        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            print("⚠️ Implementing \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.delete( items: items, offsets: offsets)
                detailsVM.items = items
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            print("⚠️ Implement \(#function) in  CDItemListView_ViewModel")
            if let model = model {
                items = model.move( items: items, from: source, to: destination)
                detailsVM.items = items
            }
        }
    }
}
