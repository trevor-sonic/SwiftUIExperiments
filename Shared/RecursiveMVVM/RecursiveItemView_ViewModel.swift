//
//  RecursiveItemView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI



// MARK: - ViewModel
extension RecursiveItemView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
      
        var rootItem: ItemBindableModel
        
        // MARK: - init
        init(rootItem: ItemBindableModel) {
                self.rootItem = rootItem
        }
        
        /// Used RecursiveItemListViews
        var recursiveItemListViews: [String:RecursiveItemListView.ViewModel] = [:]{
            didSet{
                print("recursiveItemListViews: \(String(describing: recursiveItemListViews))")

            }
        }
        
        
        func getListViewModel(for uuid: String, parent: ItemBindableModel? = nil) -> RecursiveItemListView.ViewModel {
            if let existOne = recursiveItemListViews[uuid] {
                return existOne
            }else{
                var parentVM: RecursiveItemListView.ViewModel?
                if let uuid = parent?.parent.value?.id.uuidString, let pVM = recursiveItemListViews[uuid]{
                    parentVM = pVM
                }
                
                let  new = RecursiveItemListView.ViewModel(parentItem: parent, parentVM: parentVM)
                recursiveItemListViews[uuid] = new
                return new
            }
        }
        
        
    }
}
