//
//  RecursiveItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI



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

        let rootItem = ItemBindableModel(title: "Root Item (Bindable)", position: 0)
        RecursiveItemView(vm: RecursiveItemView.ViewModel(rootItem: rootItem))
    }
}
