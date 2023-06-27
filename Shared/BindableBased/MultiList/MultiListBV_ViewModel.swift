//
//  MultiListBV_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI


extension MultiListBV {
    @MainActor
    class ViewModel: ObservableObject {
        
        
        @Published var listVM1: ItemListBV.ViewModel
        
        @Published var listVM2: ItemListBV.ViewModel
        
//        init(listVM1: ItemListBV.ViewModel, listVM2: ItemListBV.ViewModel) {
//            self.listVM1 = listVM1
//            self.listVM2 = listVM2
//        }
        
        
        var multiListBM: MultiListBModel?
        
        init(){
            multiListBM = MultiListBModel()
            listVM1 = ItemListBV.ViewModel(items: multiListBM!.items1)
            
            listVM2 = ItemListBV.ViewModel(items: multiListBM!.items2)
        }
    }
}
