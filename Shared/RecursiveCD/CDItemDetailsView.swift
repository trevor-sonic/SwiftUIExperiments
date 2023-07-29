//
//  CDItemDetailsView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI




// MARK: - View
struct CDItemDetailsView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm: ViewModel
    
    @State var needUpdate: Bool = false
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    
    var body: some View {
        Section("Item Details"){
            

            if let item = vm.item {
                // read only prooperties
                VStack(alignment: .leading){
                    Text("UUID:" + (vm.item?.uuidAsString ?? "uuid?"))
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Text("Position: \(item.position)").foregroundColor(.gray)
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Text("Child count: \(vm.items.count)").foregroundColor(.gray)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                // Title
                NavigationLink {
                    TextInputView(vm: vm.titleVM, forEditing: true)
                } label: {
                    TextInputView(vm: vm.titleVM, forEditing: false)
                }
                
            
                // Name
                NavigationLink {
                    TextInputView(vm: vm.nameVM, forEditing: true)
                } label: {
                    TextInputView(vm: vm.nameVM, forEditing: false)
                }
                
                // ValueType & Value
                NavigationLink {
                    TypesListView(vm: vm.typeListVM)
                }label: {
                    TextInputView(vm: vm.typeCellVM, forEditing: false)
                }
                
                
            }
            
            EmptyView().disabled(vm.needUpdate)
        }
        
    }
}



// MARK: - Preview
//struct CDItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let item = ItemBindableModel(title: "Test", position: 0)
//        CDItemDetailsView(vm: CDItemDetailsView.ViewModel(item: item))
//    }
//}
