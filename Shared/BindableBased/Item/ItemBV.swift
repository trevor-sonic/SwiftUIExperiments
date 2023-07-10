//
//  ItemBV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 26/06/2023.
//

import SwiftUI



// MARK: - View
struct ItemBV: View {
    
    @ObservedObject var vm: ItemBV.ViewModel
    let onSelect: ClosureWith<ItemBindableModel>
    let onValueChange: ClosureBasic
    
    // MARK: - Bindables
    @MainActor var nameField: Binding<String> {
        Binding {
            self.vm.name.wrappedValue
        } set: {
            // 500 characters for "unlimited" text input
            self.vm.name.wrappedValue = String($0.prefix(500))
            
            self.onValueChange()
        }
    }
    
    init(vm: ItemBV.ViewModel, forEditing: Bool = false,
         onSelect: @escaping ClosureWith<ItemBindableModel>,
         onValueChange: @escaping ClosureBasic) {
        self.vm = vm
        self.onSelect = onSelect
        self.onValueChange = onValueChange
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
            Text( "\(vm.item.position.value) - " + (vm.item.title.value) )
                .foregroundColor(.gray)
                .padding(.vertical)
        }
        

    }
}


// MARK: - Preview
struct ItemBV_Previews: PreviewProvider {
    static var previews: some View {
        
        let forEditing = true
        let item = ItemBindableModel(title: "Bindable Name", position: 5)
        let vm = ItemBV.ViewModel(item: item, forEditing: forEditing)
        
        if forEditing {
            
                ItemBV(vm: vm,
                       onSelect: { _ in },
                       onValueChange: {})
            
        }else{
            List{
                ItemBV(vm: vm,
                       onSelect: { _ in },
                       onValueChange: {})
            }
        }
    }
}
