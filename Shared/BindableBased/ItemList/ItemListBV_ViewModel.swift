//
//  ItemListBV_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI

extension ItemListBV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var items: [ItemBindableModel]
        @Published var selectedItem: ItemBindableModel?
        
        init(items: [ItemBindableModel]) {
            self.items = items
        }
    }
}
