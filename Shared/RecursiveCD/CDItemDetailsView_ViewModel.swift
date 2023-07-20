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
        @Published var typeListVM = TypesListView.ViewModel() // for choosing the type
        @Published var titleVM = TextInputView.ViewModel()
        @Published var nameVM = TextInputView.ViewModel()
        @Published var typeCellVM = TextInputView.ViewModel() // for displaying the type in the list cell
        
        
        @Published var needUpdate: Bool = false
        
        init(item: Item?) {
            self.item = item
            self.items = item?.itemsAsArray ?? []
            
            guard let item = self.item else {return}
            
            
            // set vars in VMs
            titleVM.text = item.title ?? "no-title"
            titleVM.info = "Title".uppercased()
            
            nameVM.text = item.name ?? "??"
            nameVM.info = "Name".uppercased()
            
            
            // Set type
            typeListVM.selectedType = item.valueType.getAsType()
            typeListVM.stringInputVM.text = item.valueString ?? "<>"
            typeListVM.intInputVM.text = "\(item.valueInt ?? -1)"
            typeListVM.doubleInputVM.text = "\(item.valueDouble.getAsDouble() ?? -1.1)"
            
            // Text cell of Type selection
            typeCellVM.info = "Type & Value".uppercased()
            typeCellVM.text = typeListVM.typeAndValueText(of: item.valueType.getAsType())
            
        }
        
        
    }
}
