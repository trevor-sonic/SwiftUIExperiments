//
//  ItemListV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI


extension ItemListV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var items: [ItemData]
        @Published var selectedItem: ItemData?
        
        init(items: [ItemData]) {
            self.items = items
        }
    }
}
struct ItemListV: View {
    
    @ObservedObject var vm: ItemListV.ViewModel
    let onSelect: ClosureWith<ItemData>
    
    init(vm: ItemListV.ViewModel, onSelect: @escaping ClosureWith<ItemData>) {
        self.vm = vm
        self.onSelect = onSelect
    }
    var body: some View {
        
        List(vm.items){ item in
            Button{
                vm.selectedItem = item
                onSelect(item)
            } label: {
                Text(item.nameWrapped)
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
            // Selected cell colour
            .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
            //.buttonStyle(PlainButtonStyle())
        }
        
    }
}

struct ItemListV_Previews: PreviewProvider {
    static var previews: some View {
        ItemListV(vm: ItemListV.ViewModel(items: ItemData.mock)){ _ in }
    }
}
