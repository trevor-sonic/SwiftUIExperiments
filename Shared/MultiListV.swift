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
    
    var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        
//        ZStack{
//            Color.green
            HStack{
                
                // List 1
                //let vm1 = ItemListV.ViewModel(items: ItemData.mock)
                ItemListV(vm: vm.list1vm)
                
                
                // List 2
                //let vm2 = ItemListV.ViewModel(items: ItemData.mockMiddle)
                ItemListV(vm: vm.list2vm)
                
                // List 3
                List(0...30, id:\.self){ n in
                    Text("Item \(n)")
                }
            } // HStack
//        } // ZStack
    }
}

struct MultiListV_Previews: PreviewProvider {
    static var previews: some View {
        MultiListV(vm: MultiListV.ViewModel())
    }
}
