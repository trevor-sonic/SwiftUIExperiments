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
        
        // Sub VMs
        @Published var typeListVM = TypesListView.ViewModel()
        @Published var itemVM: CDItemView.ViewModel = CDItemView.ViewModel()
        
        
        @Published var needUpdate: Bool = false
        
        init(item: Item?) {
            self.item = item
            self.items = item?.itemsAsArray ?? []
            itemVM.nameHolder = item?.title ?? "not set"
            typeListVM.selectedType = item?.valueType.getAsType()
           
            
            typeListVM
                .$selectedType
                .sink { [weak self] value in
                    print("selectedType value: \(String(describing: value)) in CDItemDetailsView")
                    self?.needUpdate.toggle()
                }
                .store(in: &cancellables)

            
        }
        
        func getItemVM(item: Item, forEditing: Bool) -> CDItemView.ViewModel {
            itemVM = CDItemView.ViewModel(item: item, forEditing: forEditing)
            return itemVM
        }
        
    }
}
