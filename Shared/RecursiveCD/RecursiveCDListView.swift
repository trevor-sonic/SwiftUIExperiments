//
//  RecursiveCDListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI


// MARK: - ViewModel
extension RecursiveCDListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - Bindables
        @Published var items: [ItemBindableModel]
        @Published var selectedItem: ItemBindableModel?{
            didSet{
                print("selectedItem: \(String(describing: selectedItem?.title.value)) and parent: \(parent?.title.value)")

            }
        }
        
        @Published var path: NavigationPath = NavigationPath() 
        
        var parent: ItemBindableModel?
        
        // MARK: - init
        init(items: [ItemBindableModel], parent: ItemBindableModel? = nil) {
            self.items = items
            self.parent = parent
        }
        
        // MARK: - methods
        func addItem(){
            print("parent: \(parent?.title.value) in RecursiveCDListView.ViewModel")
            let newItem = ItemBindableModel(name: "New Item \((10...99).randomElement()!)", position: 100, parent: parent)
            items.append(newItem)
            
        }
        
    }
}

// MARK: - View
struct RecursiveCDListView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        
        List(vm.items, id: \.id) { item in
            
            //                NavigationLink(item.title.value, value: item )
            
            NavigationLink(value: item) {
                ItemBV(vm: ItemBV.ViewModel(item: item)) { selectedItem in
                    // Handle item selection here
                    //vm.selectedItem = selectedItem
                    
                } onValueChange: {
                    // Handle value change here
                }
                
                .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
                
                
            }
            
        }
        
        .navigationBarItems(
            trailing:
                Button{
                    vm.addItem()
                } label: {
                    Text("Add")
                    
                })

    }
}





// MARK: - Preview
struct RecursiveCDListView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            ItemBindableModel(name: "Item 1", position: 1),
            ItemBindableModel(name: "Item 2", position: 2),
            ItemBindableModel(name: "Item 3", position: 3)
            ]
        
        
            
//            , items: [
//                ItemBindableModel(name: "Item 3.1", position: 1),
//                ItemBindableModel(name: "Item 3.2", position: 2,  items: [
//                    ItemBindableModel(name: "Item 3.2.1", position: 1),
//                    ItemBindableModel(name: "Item 3.2.2", position: 2),
//                    ItemBindableModel(name: "Item 3.2.3", position: 3)
//                ]),
//                ItemBindableModel(name: "Item 3.3", position: 3)
//            ]),
//            ItemBindableModel(name: "Item 4", position: 4)
//        ]
        
        RecursiveCDListView(vm: RecursiveCDListView.ViewModel(items: items))
    }
}
