//
//  CDItemView_ViewModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI


// MARK: - ViewModel
extension TextInputView {
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - SwiftUI View Holders
        @Published var text: String = ""
        @Published var info: String = ""
        
        init(text: String? = nil, info: String? = nil){
            self.text = text ?? ""
            self.info = info ?? ""
        }
        
    }
}

