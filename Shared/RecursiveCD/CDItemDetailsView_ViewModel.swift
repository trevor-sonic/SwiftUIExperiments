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
        @Published var titleVM = TextInputView.ViewModel()
        @Published var nameVM = TextInputView.ViewModel()
        @Published var typeCellVM = TextInputView.ViewModel()
        
        
        @Published var needUpdate: Bool = false
        
        init(item: Item?) {
            self.item = item
            self.items = item?.itemsAsArray ?? []
            
            // set vars in VMs
            titleVM.text = item?.title ?? "no-title"
            titleVM.info = "Title".uppercased()
            
            nameVM.text = item?.name ?? "??"
            nameVM.info = "Name".uppercased()
            
            
            typeCellVM.text = item?.valueType.getAsStringDescription() ?? "unknown type"
            typeCellVM.info = "Type".uppercased()
            typeListVM.selectedType = item?.valueType.getAsType()
            
           
            // listeners
            listenTypeChanges()
        }
        
        // Type changes listener
        func listenTypeChanges(){
            typeListVM
                .$selectedType
                .sink { [weak self] value in
                    print("selectedType value: \(String(describing: value)) in CDItemDetailsView")
                    self?.typeCellVM.text = value?.description ?? "typeCellVM.text desc ??"
                    self?.needUpdate.toggle()
                }
                .store(in: &cancellables)
        }
    }
}
