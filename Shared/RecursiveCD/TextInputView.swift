//
//  CDItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - View
struct TextInputView: View {
    

    /// ViewModel
    @ObservedObject var vm: TextInputView.ViewModel
    
    @State var forEditing: Bool
   
    // MARK: - Bindables
//    @MainActor var nameField: Binding<String> {
//        Binding {
//            self.vm.text
//        } set: {
//            // 500 characters for "unlimited" text input
//            self.vm.text = String($0.prefix(500))
//        }
//    }
    
    init(vm: TextInputView.ViewModel, forEditing: Bool = false) {
        self.vm = vm
        self.forEditing = forEditing
    }
    
    var body: some View {
        
        if forEditing {
            
                
                TextEditor(text: $vm.text)
                    .cornerRadius(10)
                    .padding(20)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.2))
                    .navigationTitle(vm.info)
                
                
            
                
//            TextField("", text: nameField)
//                .font(.title)
//                .foregroundColor(.orange)
//                .background(.cyan)
//                .padding()
            
        }else{
            ZStack{
                
                // Corner info text
                VStack{
                    HStack(alignment:.top){
                        Text(vm.info)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .offset(CGSize(width: 0, height: 4))
                        Spacer()
                    }
                    Spacer()
                }
                
                // main text
                HStack{
                    Text(vm.text)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                        
                    Spacer()
                }
            } // ZStack
            
        }
    }
}


// MARK: - Preview
struct CDItemView_Previews: PreviewProvider {
    static var previews: some View {

        let forEditing = false
        let vm = TextInputView.ViewModel(text: "Some Text  ailuhsd fiuahsd ofiuhaso diufhaos diuhfo aisudhfoi uasdhoif uahsdo foaisu dhfoiau sdhofi uahsdof  oiasudhfo aiusdhfo iuadosfiuhaosidufh", info: "Title")

        if forEditing {
            
            TextInputView(vm: vm, forEditing: forEditing)
            
        }else{
            
            List{
                TextInputView(vm: vm, forEditing: forEditing)
            }
        }
    }
}
