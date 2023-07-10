//
//  RecursiveItemDetailsView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI




// MARK: - View
struct RecursiveItemDetailsView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Section("Item Details"){
            Text("UUID:" + vm.item.id.uuidString).foregroundColor(.gray).font(.caption)
            //Text("Title: \(vm.item.title.value)").foregroundColor(.gray)
            NavigationLink {
//                ItemBV(vm: ItemBV.ViewModel(item: vm.item, forEditing: true)) { _ in } onValueChange: { }
                Text(vm.item.title.value).font(.title).foregroundColor(.red)
            } label: {
                ItemBV(vm: ItemBV.ViewModel(item: vm.item)) { _ in } onValueChange: { }
            }

//            NavigationLink(value: vm.item) {
//                ItemBV(vm: ItemBV.ViewModel(item: vm.item)) { _ in } onValueChange: { }
//            }
            Text("Type: \(vm.item.valueType.value.description)").foregroundColor(.gray)
            
                Text("Name: \(vm.item.name.value)").foregroundColor(.gray)
            
            Text("Value: \(vm.item.valueString.value)").foregroundColor(.gray)
            
            Text("Position: \(vm.item.position.value)").foregroundColor(.gray)
            Text("Child count: \(vm.items.count)").foregroundColor(.gray)
        }
    }
}

struct RecursiveItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let item = ItemBindableModel(title: "Test", position: 0)
        RecursiveItemDetailsView(vm: RecursiveItemDetailsView.ViewModel(item: item))
    }
}
