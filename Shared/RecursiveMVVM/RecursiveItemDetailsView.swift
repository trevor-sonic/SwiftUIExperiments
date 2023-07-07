//
//  RecursiveItemDetailsView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 07/07/2023.
//

import SwiftUI


// MARK: - ViewModel
extension RecursiveItemDetailsView {
    @MainActor
    class ViewModel: ObservableObject {
        
        var item: ItemBindableModel
        
        init(item: ItemBindableModel) {
            self.item = item
        }
    }
}

// MARK: - View
struct RecursiveItemDetailsView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Section("Item Details"){
            Text("UUID:" + vm.item.id.uuidString).foregroundColor(.gray).font(.caption)
            //Text("Title: \(parentItem.title.value)").foregroundColor(.gray)
            ItemBV(vm: ItemBV.ViewModel(item: vm.item)) { _ in } onValueChange: { }
            Text("Type: \(vm.item.valueType.value.description)").foregroundColor(.gray)
            Text("Name: \(vm.item.name.value)").foregroundColor(.gray)
            Text("Value: \(vm.item.valueString.value)").foregroundColor(.gray)
            
            Text("Position: \(vm.item.position.value)").foregroundColor(.gray)
            Text("Child count: \(vm.item.items.value.count)").foregroundColor(.gray)
        }
    }
}

struct RecursiveItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let item = ItemBindableModel(title: "Test", position: 0)
        RecursiveItemDetailsView(vm: RecursiveItemDetailsView.ViewModel(item: item))
    }
}
