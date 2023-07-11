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
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Section("Item Details"){
            Text("UUID:" + (vm.item?.uuidAsString ?? "uuid?")).foregroundColor(.gray).font(.caption)
            
            //Text("Title: \(vm.item.title.value)").foregroundColor(.gray)
            NavigationLink {
                if let item = vm.item {
                    let itemVM = CDItemView.ViewModel(item: item, forEditing: true)
                    CDItemView(vm: itemVM)
                        .environment(\.managedObjectContext, moc)
                }
            } label: {
                Text(vm.item?.title ?? "No - title")
                //ItemBV(vm: ItemBV.ViewModel(item: vm.item)) { _ in } onValueChange: { }
//                if let item = vm.item {
//                    let itemVM = CDItemView.ViewModel(item: item, forEditing: true)
//                    CDItemView(vm: itemVM)
//                }
            }

//            NavigationLink(value: vm.item) {
//                ItemBV(vm: ItemBV.ViewModel(item: vm.item)) { _ in } onValueChange: { }
//            }
            Text("Type: \(vm.item?.valueType?.description ?? "?")").foregroundColor(.gray)
            
                Text("Name: \(vm.item?.name ?? "")").foregroundColor(.gray)
            
            Text("Value: \(vm.item?.valueString ?? "")").foregroundColor(.gray)
            
            Text("Position: \(vm.item?.position ?? 0)").foregroundColor(.gray)
            Text("Child count: \(vm.items.count)").foregroundColor(.gray)
        }
        .onChange(of: vm.item) { _ in
            print("⚠️ vm.item changed in CDItemDetailsView")
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
