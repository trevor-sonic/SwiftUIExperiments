//
//  RecursiveItemListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI

// MARK: - ViewModel
extension RecursiveItemListView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - Bindables
        @Published var items: [ItemBindableModel]
        @Published var selectedItem: ItemBindableModel?{
            didSet{
                print("selectedItem: \(String(describing: selectedItem?.name.value))")
            }
        }
        
        @Published var path: NavigationPath = NavigationPath()
        
        var navigationTitle: String {
            return parent?.name.value ?? "Root"
        }
        
        // MARK: - Relational vars
        var parent: ItemBindableModel?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(items: [ItemBindableModel], parent: ItemBindableModel? = nil, parentVM: ViewModel? = nil) {
            self.items = items
            self.parent = parent
            self.parentVM = parentVM
        }
        
        // MARK: - methods
        func addItem(){
            print("parent: \(parent?.name.value) in RecursiveCDListView.ViewModel")
            let newItem = ItemBindableModel(name: "New Item \((10...99).randomElement()!)", position: 100, parent: parent)
            items.append(newItem)
            
        }
        
    }
}

// MARK: - View
struct RecursiveItemListView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List{
            ForEach(vm.items, id: \.id) { item in
                NavigationLink(value: item) {
                    ItemBV(vm: ItemBV.ViewModel(item: item)) { _ in } onValueChange: { }
                }
                .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
                
            }
        }
        .navigationTitle(vm.navigationTitle)
        .navigationBarItems(
            trailing:
                Button{
                    vm.addItem()
                } label: {
                    Text("Add")
                    
                })
        .onAppear{
            vm.parentVM?.selectedItem = vm.parent
        }
    }
}

// MARK: - Preview
struct RecursiveItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            ItemBindableModel(name: "Item 1", position: 1),
            ItemBindableModel(name: "Item 2", position: 2),
            ItemBindableModel(name: "Item 3", position: 3, items: [
                ItemBindableModel(name: "Item 3.1", position: 1),
                ItemBindableModel(name: "Item 3.2", position: 2,  items: [
                    ItemBindableModel(name: "Item 3.2.1", position: 1),
                    ItemBindableModel(name: "Item 3.2.2", position: 2),
                    ItemBindableModel(name: "Item 3.2.3", position: 3)
                ]),
                ItemBindableModel(name: "Item 3.3", position: 3)
            ]),
            ItemBindableModel(name: "Item 4", position: 4)
        ]
        
        RecursiveItemListView(vm: RecursiveItemListView.ViewModel(items: items))
    }
}

