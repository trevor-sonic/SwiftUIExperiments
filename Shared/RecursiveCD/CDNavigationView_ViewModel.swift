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
        var itemListVMs: [String:CDItemListView.ViewModel] = [:]{
            didSet{
                print("recursiveItemListViews:")
                itemListVMs.map{ (key, _) in
                    print("\(key)")
                }
            }
        }
        
        
        func getListViewModel(for uuid: String, parent: Item? = nil) -> CDItemListView.ViewModel {
            if let existOne = itemListVMs[uuid] {
                return existOne
            }else{
                var parentVM: CDItemListView.ViewModel?
                
                
                print("New ParentVM")
                print("title: \(String(describing: parent?.title))")
                print("uuid: \(String(describing: parent?.uuidAsString))")

                
                if let uuid = parent?.parent?.uuidAsString,
                    let pVM = itemListVMs[uuid]{
                    print("uuid: \(String(describing: parent?.uuidAsString)) found and set.")
                    parentVM = pVM
                }else{
                    print("uuid: \(String(describing: parent?.uuidAsString)) not found NIL")
                }
                
                let  new = CDItemListView.ViewModel(parentItem: parent, parentVM: parentVM)
                itemListVMs[uuid] = new
                return new
            }
        }
        
        
    }
}
