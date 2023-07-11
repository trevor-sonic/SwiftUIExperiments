//
//  RecursiveItemDetailsView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension RecursiveItemDetailsView {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: ItemBindableModel
        @Published var items: [ItemBindableModel] = []
        
        
        init(item: ItemBindableModel) {
            self.item = item
            
            item.items.bind(.ui, andSet: true) { [weak self] items in
                self?.items = items
            }
        }
    }
}
