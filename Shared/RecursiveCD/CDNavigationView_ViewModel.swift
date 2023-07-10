//
//  CDItemView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI
import CoreData

// MARK: - ViewModel
extension CDNavigationView {
    
    @MainActor
    class ViewModel: ObservableObject {
        

        var moc: NSManagedObjectContext?
        var rootItem: Item?
        
        // MARK: - init
        init(rootItem: Item?, moc: NSManagedObjectContext) {
            self.rootItem = rootItem
            self.moc = moc
        }
        
        /// Used RecursiveItemListViews
        var recursiveItemListViews: [String:CDItemListView.ViewModel] = [:]{
            didSet{
                print("recursiveItemListViews:")
                recursiveItemListViews.map{ (key, _) in
                    print("\(key)")
                }
            }
        }
        
        
        func getListViewModel(for uuid: String, parent: Item? = nil) -> CDItemListView.ViewModel {
            if let existOne = recursiveItemListViews[uuid] {
                return existOne
            }else{
                var parentVM: CDItemListView.ViewModel?
                if let uuid = parent?.uuidAsString,
                    let pVM = recursiveItemListViews[uuid]{
                    parentVM = pVM
                }
                
                let  new = CDItemListView.ViewModel(parentItem: parent, parentVM: parentVM, moc: moc)
                recursiveItemListViews[uuid] = new
                return new
            }
        }
        
        
    }
}
