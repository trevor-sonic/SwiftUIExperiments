//
//  CDItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 10/07/2023.
//

import SwiftUI

// MARK: - View
struct CDItemView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm: CDItemView.ViewModel
    @State var forEditing: Bool
   
    // MARK: - Bindables
    @MainActor var nameField: Binding<String> {
        Binding {
            //self.vm.title.wrappedValue
            self.vm.nameHolder
        } set: {
            // 500 characters for "unlimited" text input
            //self.vm.title.wrappedValue = String($0.prefix(500))
            self.vm.nameHolder = String($0.prefix(500))
            //self.onChange()
        }
    }
    
    var onChange: ClosureBasic
    
    init(vm: CDItemView.ViewModel, forEditing: Bool = false, onChange: @escaping ClosureBasic) {
        self.vm = vm
        self.onChange = onChange
        self.forEditing = forEditing
    }
    
    var body: some View {
        
        if forEditing {
            
            TextEditor(text: $vm.nameHolder)
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
            Text( "\(vm.item?.position ?? -1) - " + vm.nameHolder )
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
