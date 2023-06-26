//
//  ItemV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 26/06/2023.
//

import SwiftUI


extension ItemV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: ItemData
        
        init(item: ItemData) {
            self.item = item
        }
    }
}

struct ItemV: View {
    
    @ObservedObject var vm: ItemV.ViewModel
    let onSelect: ClosureWith<ItemData>
    
    init(vm: ItemV.ViewModel, onSelect: @escaping ClosureWith<ItemData>) {
        self.vm = vm
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button{
            withAnimation{
                onSelect(vm.item)
            }
        } label: {
            Text(vm.item.nameWrapped)
                .foregroundColor(.gray)
                .padding(.vertical)
        }
    }
}

struct ItemV_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ItemV(vm: ItemV.ViewModel(item: ItemData(name: "Test Name"))){ _ in }
        }
    }
}
