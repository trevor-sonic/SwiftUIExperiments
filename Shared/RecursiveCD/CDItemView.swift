//
//  CDItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - View
struct CDItemView: View {
    
    @ObservedObject var vm: CDItemView.ViewModel
    
   
    // MARK: - Bindables
    @MainActor var nameField: Binding<String> {
        Binding {
            self.vm.name.wrappedValue
        } set: {
            // 500 characters for "unlimited" text input
            self.vm.name.wrappedValue = String($0.prefix(500))
            
        }
    }
    
    init(vm: CDItemView.ViewModel, forEditing: Bool = false) {
        self.vm = vm
    }
    
    var body: some View {
        
        if vm.forEditing {
            
            TextEditor(text: nameField)
                .cornerRadius(10)
                .padding(20)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.2))
                
//            TextField("", text: nameField)
//                .font(.title)
//                .foregroundColor(.orange)
//                .background(.cyan)
//                .padding()
            
            
            
        }else{
            Text( "\(vm.item.position) - " + (vm.item.title ?? "nil..") )
                .foregroundColor(.gray)
                .padding(.vertical)
        }
        

    }
}


// MARK: - Preview
//struct CDItemView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let forEditing = true
//        let item = ItemBindableModel(title: "Bindable Name", position: 5)
//        let vm = CDItemView.ViewModel(item: item, forEditing: forEditing)
//
//        if forEditing {
//
//                CDItemView(vm: vm,
//                       onSelect: { _ in },
//                       onValueChange: {})
//
//        }else{
//            List{
//                CDItemView(vm: vm,
//                       onSelect: { _ in },
//                       onValueChange: {})
//            }
//        }
//    }
//}
