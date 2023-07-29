//
//  ObjectView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 29/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension ObjectView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var isMasterObject: Bool = false
    }
    
}

// MARK: - View
struct ObjectView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            Toggle("**Master Object**", isOn: $vm.isMasterObject)
                .foregroundColor(.gray)
                .tint(.cyan)
                .padding(60)
                
            Text("**Master Object** is the original blue print of an defined object. When a **Master Object** is modified, all other instances are automatically updated.")
                .foregroundColor(.gray)
                .padding(50)
        }.navigationTitle("Object Property")
    }
}

#Preview {
    NavigationStack{
        ObjectView(vm: ObjectView.ViewModel())
    }
        
}
