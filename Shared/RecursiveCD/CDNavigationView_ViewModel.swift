//
//  CDItemView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI
import CoreData
import Combine

// MARK: - ViewModel
extension CDNavigationView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
        var cancellables = Set<AnyCancellable>()

        //var moc: NSManagedObjectContext?
        @Published var rootItem: Item?
        
        let moc = PersistenceController.shared.container.viewContext
        
        @Published var needUpdate: Bool = false
        
        
        // MARK: - init
        init() {
            let _ = ItemCRUD().addInitialItem()
            loadRootItem()
        }
       
        func loadRootItem(){
            
            print("⚠️ Implementing \(#function) in CDNavigation")
            let rootItem = ItemCRUD().findBy(name: ItemCRUD.rootItemName).first
            self.rootItem = rootItem
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
                
                
//                print("New ParentVM")
//                print("title: \(String(describing: parent?.title))")
//                print("uuid: \(String(describing: parent?.uuidAsString))")

                
                if let uuid = parent?.parent?.uuidAsString,
                    let pVM = itemListVMs[uuid]{
                    //print("uuid: \(String(describing: parent?.uuidAsString)) found and set.")
                    parentVM = pVM
                }else{
                    //print("uuid: \(String(describing: parent?.uuidAsString)) not found NIL")
                }
                
                let  new = CDItemListView.ViewModel(parentItem: parent, parentVM: parentVM)
                itemListVMs[uuid] = new
                
                _ = new
                    .$needUpdate
                    .sink { [weak self] _ in
                        
                        DispatchQueue.main.async {
                            //self?.loadRootItem()
                            self?.needUpdate.toggle()
                        }
                        
                    }
                    .store(in: &cancellables)
                
                return new
            }
        }
        
        
    }
}
