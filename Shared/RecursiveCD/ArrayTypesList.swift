//
//  ArrayTypesList.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 28/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension ArrayTypesList {
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var arrayTypes: [Item.ValueType] = Item.ValueType.arrayTypes
        @Published var objectNames: [String] = [] {
            didSet{
                objectNames.forEach { objectName in
                    let object = Item.ValueType.object(objectName)
                    arrayTypes.append(object)
                }
            }
        }
        
        @Published var selectedType: Item.ValueType? 
        
    }
}

// MARK: - View
struct ArrayTypesList: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    var body: some View {
        List(selection: $vm.selectedType){
            ForEach(vm.arrayTypes, id: \.self){ arrayType in
                
                Group{
                    switch arrayType {
                        
                    case .object(let name):
                        Text(arrayType.description + " → " + (name ?? ""))
                            .foregroundStyle(.gray)
                            .padding(10)
                        
                    default:
                        Text(arrayType.description)
                            .foregroundStyle(.gray)
                            .padding(10)
                        
                    }
                }
                .listRowBackground(arrayType == vm.selectedType ? Color(.systemFill) : nil)
                .contentShape(Rectangle())
            }
            
        }.navigationTitle("Array Type")
        
    }
}

#Preview {
    NavigationStack{
        NavigationLink{
            Text("Nothing")
        } label: {
            ArrayTypesList(vm: ArrayTypesList.ViewModel())
        }
        .navigationTitle("Array Types")
        .foregroundColor(.gray)
    }
}
