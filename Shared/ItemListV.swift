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
        
        init(items: [ItemData]) {
            self.items = items
        }
    }
}
struct ItemListV: View {
    
    var vm: ItemListV.ViewModel
    
    
    var body: some View {
        List(vm.items){ item in
            Text(item.nameWrapped)
        }
    }
}

struct ItemListV_Previews: PreviewProvider {
    static var previews: some View {
        ItemListV(vm: ItemListV.ViewModel(items: ItemData.mock))
    }
}
