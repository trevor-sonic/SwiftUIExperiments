//
//  CDItemDetailsView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension CDItemDetailsView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: Item
        @Published var items: [Item] = []
        
        
        init(item: Item) {
            self.item = item
        }
        
        
        
    }
}
