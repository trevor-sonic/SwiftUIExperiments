//
//  ItemListBV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI




struct ItemListBV: View {
    
    @ObservedObject var vm: ItemListBV.ViewModel
    let onSelect: ClosureWith<ItemBindableModel>
    
    init(vm: ItemListBV.ViewModel, onSelect: @escaping ClosureWith<ItemBindableModel>) {
        self.vm = vm
        self.onSelect = onSelect
    }
    
    var body: some View {
        
        List(vm.items){ item in
            ItemBV(vm: ItemBV.ViewModel(item: item), onSelect: { selectedItemModel in
                
                vm.selectedItem = selectedItemModel
                onSelect(selectedItemModel)

            }, onValueChange: {})
            // Selected cell colour
            .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
        }
        
    }
}

struct ItemListBV_Previews: PreviewProvider {
    static var previews: some View {
        
        let itemListBM = ItemListBM()
        let items = itemListBM.fetchAllItems()
        ItemListBV(vm: ItemListBV.ViewModel(items: items)) { _ in }
        
    }
}
