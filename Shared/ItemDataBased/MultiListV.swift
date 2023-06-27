//
//  MultiListV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI





extension MultiListV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var list1vm: ItemListV.ViewModel = ItemListV.ViewModel(items: ItemData.mock)
        @Published var list2vm: ItemListV.ViewModel = ItemListV.ViewModel(items: ItemData.mockMiddle)
        @Published var list3vm: ItemListV.ViewModel = ItemListV.ViewModel(items: [])
        
    }
}


struct MultiListV: View {
    
    @ObservedObject var vm: ViewModel
    let onSelect: ClosureWith<(Int, ItemData)>
    
    init(vm: ViewModel, onSelect: @escaping ClosureWith<(Int, ItemData)>) {
        self.vm = vm
        self.onSelect = onSelect
    }
    
    var body: some View {

            HStack{
                
                // List 1
                ItemListV(vm: vm.list1vm) { itemData in
                    onSelect((0,itemData))
                }
                
                
                // List 2
                ItemListV(vm: vm.list2vm) { itemData in
                    //vm.list2SelectedItem.wrappedValue = itemData
                    
                        onSelect((1,itemData))
                    
                }
                
                // List 3
                ItemListV(vm: vm.list3vm) { itemData in
                    onSelect((2,itemData))
                }
            } // HStack
    }
}

struct MultiListV_Previews: PreviewProvider {
    static var previews: some View {
        MultiListV(vm: MultiListV.ViewModel()){ _ in
            
        }
    }
}
