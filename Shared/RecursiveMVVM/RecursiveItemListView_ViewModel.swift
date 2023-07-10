//
//  RecursiveItemListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension RecursiveItemListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - Bindables
        @Published var items: [ItemBindableModel]
        @Published var selectedItem: ItemBindableModel?{
            didSet{
                print("selectedItem: \(String(describing: selectedItem?.title.value))")
            }
        }
        
        @Published var path: NavigationPath = NavigationPath()
        
        var navigationTitle: String {
            return parentItem?.title.value ?? "Root"
        }
        
        // MARK: - Relational vars
        var parentItem: ItemBindableModel?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(parentItem: ItemBindableModel? = nil, parentVM: ViewModel? = nil) {
        
            self.items = parentItem?.items.value ?? []
            
            self.parentItem = parentItem
            self.parentVM = parentVM
        }
        
        // MARK: - methods
        /// Add item
        func addItem(){
            print("parent: \(parentItem?.title.value) in RecursiveCDListView.ViewModel")
            let newItem = ItemBindableModel(title: "New Item \((10...99).randomElement()!)", position: 0, parent: parentItem)
            
            if let parent = self.parentItem {
                items = parent.items.value
            }

        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            parentItem?.items.value.remove(atOffsets: offsets)
            
            if let parent = self.parentItem {
                items = parent.items.value
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            if let parent = self.parentItem {
                parent.items.value.move(fromOffsets: source, toOffset: destination)
                items = parent.items.value
            }
        }
    }
}
