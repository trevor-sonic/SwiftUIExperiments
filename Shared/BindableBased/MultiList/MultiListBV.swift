//
//  MultiListBV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI



struct MultiListBV: View {
    
    @ObservedObject var listVM1: ItemListBV.ViewModel
    @ObservedObject var listVM2: ItemListBV.ViewModel
    
    
    
    var body: some View {
        HStack{
            

            ItemListBV(vm: listVM1) { _ in }
            ItemListBV(vm: listVM2) { _ in }
            
            
            
            
        }
    }
}

struct MultiListBV_Previews: PreviewProvider {
    static var previews: some View {
        let mm = MultiListBModel()
        
        MultiListBV(listVM1: ItemListBV.ViewModel(items: mm.items1), listVM2: ItemListBV.ViewModel(items: mm.items1))

       
        //(vm: MainHolderV.ViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone Landscape")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
