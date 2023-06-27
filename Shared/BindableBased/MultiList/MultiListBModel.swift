//
//  MultiListBModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import Foundation

class MultiListBModel {
    
    var listModel1: ItemListBM
    var listModel2: ItemListBM
    
    var items1: [ItemBindableModel] = []
    var items2: [ItemBindableModel] = []
    
    init(listModel1: ItemListBM, listModel2: ItemListBM) {
        self.listModel1 = listModel1
        self.listModel2 = listModel2
    }
    
    init(){
        listModel1 = ItemListBM()
        items1 = listModel1.fetchAllItems()
    
        
        listModel2 = ItemListBM()
        items2 = listModel2.fetchAllItems()
    }
}
