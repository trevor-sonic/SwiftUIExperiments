//
//  ItemBV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 26/06/2023.
//

import SwiftUI


extension ItemBV {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var item: ItemBindableModel
        
        // MARK: - SwiftUI View Holders
        @Published var nameHolder: String = ""
        
        // MARK: - bindables with Model
        var name: Binding<String> {
            Binding(
                get: {
                    //print("get called \(self.item.name.value) in ItemBV.ViewModel")
                    return self.item.name.value
                    
                },
                set: {
                    // Update UI -> Model
                    self.item.name.value = $0
                    self.nameHolder = $0
                    //print("name: \($0) in ItemBV.ViewModel")

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
            item.name.bind(.ui, andSet: true) {[weak self] value in
                if self?.nameHolder != value{
                    self?.nameHolder = value
                }
            }
        }
    }
}

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
        Button{
            withAnimation{
                onSelect(vm.item)
            }
        } label: {
            //Text(vm.item.name.value)
            TextField("", text: nameField)
                .foregroundColor(.gray)
                .padding(.vertical)
        }
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