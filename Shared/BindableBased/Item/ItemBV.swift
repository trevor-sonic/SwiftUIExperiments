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
    
    
    init(vm: ItemBV.ViewModel,
         onSelect: @escaping ClosureWith<ItemBindableModel>,
         onValueChange: @escaping ClosureBasic) {
        self.vm = vm
        self.onSelect = onSelect
        self.onValueChange = onValueChange
    }
    
    var body: some View {
        Text( "\(vm.item?.position.value ?? -1) - " + (vm.item?.title.value ?? "") )
            .foregroundColor(.gray)
            .padding(.vertical)
//        Button{
//            withAnimation{
//                if let item = vm.item {
//                    onSelect(item)
//                }
//            }
//        } label: {
//            //Text(vm.item.title.value)
//            TextField("", text: nameField)
//                //.foregroundColor(.gray)
//                .padding(.vertical)
//        }
    }
}


// MARK: - Preview
struct ItemBV_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ItemBV(vm: ItemBV.ViewModel(
                item: ItemBindableModel(name: "Bindable Name",
                                position: 5)),
                   onSelect: { _ in },
                   onValueChange: {})
        }
    }
}
