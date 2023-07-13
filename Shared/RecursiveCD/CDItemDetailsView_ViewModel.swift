//
//  CDItemDetailsView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI
import Combine

// MARK: - ViewModel
extension CDItemDetailsView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        var cancellables = Set<AnyCancellable>()
        
        @Published var item: Item?
        @Published var items: [Item] = []
        
        @Published var typeListVM = TypesListView.ViewModel()
        
        @Published var needUpdate: Bool = false
        
        init(item: Item?) {
            self.item = item
            self.items = item?.itemsAsArray ?? []
            
            
             typeListVM
                .$selectedType
                .sink { [weak self] value in
                    print("selectedType value: \(String(describing: value)) in CDItemDetailsView")
                    self?.needUpdate.toggle()
                }
                .store(in: &cancellables)

            
        }
        
        
        
    }
}
