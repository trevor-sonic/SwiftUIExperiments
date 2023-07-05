//
//  RecursiveItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension RecursiveItemView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        
        var rootItem: ItemBindableModel = ItemBindableModel(name: "Root Item", position: 0)
        
        
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
                if let uuid = parent?.parent?.id.uuidString, let pVM = recursiveItemListViews[uuid]{
                    parentVM = pVM
                }
                
                let  new = RecursiveItemListView.ViewModel(items: [], parentItem: parent, parentVM: parentVM)
                recursiveItemListViews[uuid] = new
                return new
            }
        }
        
        
    }
}

// MARK: - View
struct RecursiveItemView: View {
    
    
    @ObservedObject var vm: ViewModel
    

    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack {
            
            RecursiveItemListView(vm: vm.getListViewModel(for: vm.rootItem.id.uuidString, parent: vm.rootItem))
            
                .navigationDestination(for: ItemBindableModel.self) { item in
                    
                    let vm = vm.getListViewModel(for: item.id.uuidString, parent: item)
                    RecursiveItemListView(vm: vm)
                }
            
                
        }
    }
}


// MARK: - Preview
struct RecursiveItemView_Previews: PreviewProvider {
    static var previews: some View {

        let items = [
                    ItemBindableModel(name: "Item 1", position: 1),
                    ItemBindableModel(name: "Item 2", position: 2),
                    ItemBindableModel(name: "Item 3", position: 3, items: [
                        ItemBindableModel(name: "Item 3.1", position: 1),
                        ItemBindableModel(name: "Item 3.2", position: 2,  items: [
                            ItemBindableModel(name: "Item 3.2.1", position: 1),
                            ItemBindableModel(name: "Item 3.2.2", position: 2),
                            ItemBindableModel(name: "Item 3.2.3", position: 3)
                        ]),
                        ItemBindableModel(name: "Item 3.3", position: 3)
                    ]),
                    ItemBindableModel(name: "Item 4", position: 4)
                ]

        //RecursiveItemView(vm: RecursiveItemListView.ViewModel(items: items))
        RecursiveItemView(vm: RecursiveItemView.ViewModel())
    }
}
