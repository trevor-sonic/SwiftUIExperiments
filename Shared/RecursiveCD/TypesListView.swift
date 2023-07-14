//
//  TypesListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 13/07/2023.
//

import SwiftUI


// MARK: - ViewModel
extension TypesListView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var types: [Item.ValueType] = Item.ValueType.allTypes
        
        @Published var selectedType: Item.ValueType?

    }
}

// MARK: - View
struct TypesListView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List{
            ForEach(vm.types, id: \.self) { type in
                
               
                HStack {
                    Text(type.description)
                        .foregroundColor(.gray)
                        .padding()

                            Spacer()
                    if type == vm.selectedType ?? .string {
                                Image(systemName: "checkmark")
                                    .font(.title2)
                            .foregroundColor(Color.accentColor)
//                                    .bold()
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.selectedType = type
//                            topicSelected = topic.name
//                            dismiss()
                        }
                
                
            }
        }
    }
}

struct TypesListView_Previews: PreviewProvider {
    static var previews: some View {
        TypesListView(vm: TypesListView.ViewModel())
    }
}
