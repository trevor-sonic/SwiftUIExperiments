//
//  ItemListBV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI


extension ItemListBV {
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - CoreData managed object
        private var moc = PersistenceController.shared.container.viewContext
        
        @Published var items: [ItemBindableModel]
        @Published var selectedItem: ItemBindableModel?
        
        init(items: [ItemBindableModel]) {
            self.items = items
            fetchAllItems()
        }
        
        func fetchAllItems(){
            let allItems = ItemCRUD().findAll()
            items = allItems.map { item in
                ItemBindableModel(item: item, moc: moc)
            }
            
        }
    }
}
struct ItemListBV: View {
    
    @ObservedObject var vm: ItemListBV.ViewModel
    let onSelect: ClosureWith<ItemBindableModel>
    
    init(vm: ItemListBV.ViewModel, onSelect: @escaping ClosureWith<ItemBindableModel>) {
        self.vm = vm
        self.onSelect = onSelect
    }
    
    var body: some View {
        
        List(vm.items){ item in
            ItemBV(vm: ItemBV.ViewModel(item: item), onSelect: { selectedItemModel in
                
                vm.selectedItem = selectedItemModel
                onSelect(selectedItemModel)

            }, onValueChange: {})
            // Selected cell colour
            .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
        }
        
    }
}

//struct ItemListBV_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListBV(vm: ItemListV.ViewModel(items: ItemData.mock)){ _ in }
//    }
//}
