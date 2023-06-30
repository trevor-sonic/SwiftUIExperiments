//
//  ItemBV_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI

extension ItemBV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: ItemBindableModel?
        
        // MARK: - SwiftUI View Holders
        @Published var nameHolder: String = ""
        
        // MARK: - bindables with Model
        var name: Binding<String> {
            Binding(
                get: {
                    self.item?.name.value ?? ""
                },
                set: {
                    // Update UI -> Model
                    self.item?.name.value = $0
                    self.nameHolder = $0
                }
            )
        }
        
        // MARK: - init
        init(item: ItemBindableModel) {
            self.item = item
            bindModelToUI()
        }
        
        // MARK: -  Update UI when name in the model has changed
        // Update Model -> UI
        func bindModelToUI(){
            item?.name.bind(.ui, andSet: true) {[weak self] value in
                if self?.nameHolder != value{
                    self?.nameHolder = value
                }
            }
        }
    }
}

