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
    private var onChange: ClosureBasic
    
    init(vm: ViewModel, onChange: @escaping ClosureBasic) {
        self.vm = vm
        self.onChange = onChange
    }
    
    
    var body: some View {
        Section("Item Details"){
            Text("UUID:" + (vm.item?.uuidAsString ?? "uuid?")).foregroundColor(.gray).font(.caption)
            
            //Text("Title: \(vm.item.title.value)").foregroundColor(.gray)
            if let item = vm.item {
                NavigationLink {
                    let itemVM = CDItemView.ViewModel(item: item, forEditing: true)
                    CDItemView(vm: itemVM){
                        print("⚠️ Implement onChange  in CDItemDetailsView")
                        self.needUpdate.toggle()
                        onChange()
                    }
                    .environment(\.managedObjectContext, moc)
                    
                } label: {
                    let itemVM = CDItemView.ViewModel(item: item, forEditing: false)
                    CDItemView(vm: itemVM){}
                        .environment(\.managedObjectContext, moc)
                    
                }
            }
            
            if let item = vm.item {
                NavigationLink{
                    TypesListView(vm: vm.typeListVM)
                }label: {
                    Text("Type: \(item.valueType.getAsStringDescription())").foregroundColor(.gray)
                }
                
                    
                
                Text("Name: \(item.name ?? "")").foregroundColor(.gray)
                
                Text("Value: \(item.valueString ?? "")").foregroundColor(.gray)
                
                Text("Position: \(item.position)").foregroundColor(.gray)
                Text("Child count: \(vm.items.count)").foregroundColor(.gray)
            }
            //Toggle("onChange", isOn: $needUpdate)
            EmptyView().disabled(needUpdate)
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
