//
//  CDItemView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

extension CDItemView {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: Item
        @Published var forEditing: Bool
        
        // MARK: - SwiftUI View Holders
        @Published var nameHolder: String = ""
        
        // MARK: - bindables with Model
        var title: Binding<String> {
            Binding(
                get: {
                    self.item.title ?? "NIL"
                },
                set: {
                    // Update UI -> Model
                    self.item.title = $0
                    self.nameHolder = $0
                    
                    ItemCRUD().update(item: self.item)
                    ItemCRUD().save()
                    
                }
            )
        }
        
        // MARK: - init
        init(item: Item, forEditing: Bool = false) {
            self.item = item
            self.forEditing = forEditing
        }
        
        
    }
}

