//
//  TypesListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 13/07/2023.
//

import SwiftUI
import Combine



// MARK: - View
struct TypesListView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack{
            List(selection: $vm.selectedType){
                ForEach(vm.types, id: \.self) { type in
                    
                    HStack {
                        NavigationLink{
                            switch type {
                            case .undefined: Text("The variable is set to **Undefined**.")
                            case .string: TextInputView(vm: vm.stringInputVM, forEditing: true)
                            case .int: TextInputView(vm: vm.intInputVM, forEditing: true)
                            case .double: TextInputView(vm: vm.doubleInputVM, forEditing: true)
                            
                            case .object(_): ObjectView(vm: vm.objectPropertyVM)
                                
                            case .array: ArrayTypesListView(vm:vm.arrayTypesListVM)
                                
                            default: Text("Unimplemented ValueType in TypeListView")
                            }
                            
                        } label: {
                            Text(vm.typeAndValueText(of: type))
                                .foregroundColor(.gray)
                                .padding()
                            
                        }
                        
                        Spacer()
                    }
                    
                    .listRowBackground(type == vm.selectedType ? Color(.systemFill) : nil)
                    .contentShape(Rectangle())
                    
                    
                    
                }
            }
            EmptyView().disabled(vm.needUpdate)
        }.navigationTitle("Variable Type")
    }
}

struct TypesListView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            let vm = TypesListView.ViewModel()
            TypesListView(vm: vm)
        }
    }
}
