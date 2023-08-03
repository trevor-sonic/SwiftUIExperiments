//
//  TypesListView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 03/08/2023.
//

import Foundation
import Combine

// MARK: - ViewModel
extension TypesListView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var needUpdate: Bool = false
        var cancellables = Set<AnyCancellable>()
        
        @Published var types: [Item.ValueType] = Item.ValueType.allTypes
        @Published var selectedType: Item.ValueType?
        //@Published var editingInputVM: TextInputView.ViewModel = TextInputView.ViewModel()
        
        // MARK: - Input VMs
        @Published var stringInputVM: TextInputView.ViewModel = TextInputView.ViewModel()
        @Published var intInputVM: TextInputView.ViewModel = TextInputView.ViewModel()
        @Published var doubleInputVM: TextInputView.ViewModel = TextInputView.ViewModel()
        
        @Published var objectPropertyVM = ObjectView.ViewModel()
        @Published var arrayTypesListVM = ArrayTypesListView.ViewModel()


        // combining type and value as one string for ui
        func typeAndValueText(of type: Item.ValueType) -> String {
            let typeWithArrow = typeWithArrow(of: type)
            switch type {
            case .undefined: return Item.ValueType.undefined.description
            case .string: return typeWithArrow + stringInputVM.text
            case .int: return typeWithArrow + intInputVM.text
            case .double: return typeWithArrow + doubleInputVM.text
            case .date: return Item.ValueType.date.description
            case .object: return Item.ValueType.object(nil).description
            case .array: return Item.ValueType.array.description
            default: return "not_Implemented"
            }
        }
        func typeWithArrow(of type: Item.ValueType? = nil) -> String {
            return (type ?? selectedType ?? .undefined).description + " → "
        }
        // MARK: - init
        
    }
}
