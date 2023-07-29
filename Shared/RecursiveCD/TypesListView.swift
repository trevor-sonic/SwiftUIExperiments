//
//  TypesListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 13/07/2023.
//

import SwiftUI
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
                            
                            case .object(_):
                                ObjectView(vm: vm.objectPropertyVM)
                                
                            case .array:
                                ArrayTypesListView(vm:vm.arrayTypesListVM)
                                
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
