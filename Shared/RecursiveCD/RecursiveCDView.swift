//
//  RecursiveCDView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI

// MARK: - View
struct RecursiveCDView: View {
    
    
    @ObservedObject var vm: RecursiveCDListView.ViewModel
    

    init(vm: RecursiveCDListView.ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack {
            
            RecursiveCDListView(vm: vm)
            
                .navigationDestination(for: ItemBindableModel.self) { item in
                    
                    let vm = RecursiveCDListView.ViewModel(items: item.items.value, parent: item)
                    RecursiveCDListView(vm: vm)
                        .onAppear{
                            vm.selectedItem = item
                        }
                }
            
                .navigationTitle("\(vm.parent?.title.value ?? "Root")")
                
        }
    }
}


// MARK: - Preview
struct RecursiveCDView_Previews: PreviewProvider {
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

        RecursiveCDView(vm: RecursiveCDListView.ViewModel(items: items))
    }
}
