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
                print("selectedItem: \(String(describing: selectedItem?.title.value))")
            }
        }
        
        @Published var path: NavigationPath = NavigationPath()
        
        var navigationTitle: String {
            return parentItem?.title.value ?? "Root"
        }
        
        // MARK: - Relational vars
        var parentItem: ItemBindableModel?
        var parentVM: ViewModel?
        
        // MARK: - init
        init(/*items: [ItemBindableModel],*/ parentItem: ItemBindableModel? = nil, parentVM: ViewModel? = nil) {
            //self.items = items
            self.items = [] //parentItem?.items.value ?? []
            //parentItem?.items.value ?? []
            self.parentItem = parentItem
            self.parentVM = parentVM
        }
        
        // MARK: - methods
        /// Add item
        func addItem(){
            print("parent: \(parentItem?.title.value) in RecursiveCDListView.ViewModel")
            let newItem = ItemBindableModel(name: "New Item \((10...99).randomElement()!)", position: 0, parent: parentItem)
            
            if let parent = self.parentItem {
                items = parent.items.value
            }

        }
        
        /// Delete item
        func delete(at offsets: IndexSet) {
            parentItem?.items.value.remove(atOffsets: offsets)
            
            if let parent = self.parentItem {
                items = parent.items.value
            }
        }
        
        /// Move - reorder item
        func move(from source: IndexSet, to destination: Int) {
            if let parent = self.parentItem {
                parent.items.value.move(fromOffsets: source, toOffset: destination)
                items = parent.items.value
            }
        }
    }
}

// MARK: - View
struct RecursiveItemListView: View {
    
    @ObservedObject var vm: ViewModel
    
    var detailsVM: RecursiveItemDetailsView.ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        let parentItem = vm.parentItem ?? ItemBindableModel(name: "Parent Item?", position: 0)
        detailsVM = RecursiveItemDetailsView.ViewModel(item: parentItem)
    }
    
    var body: some View {
        VStack{
            List{
                
                // Details View
                RecursiveItemDetailsView(vm: detailsVM)
                
                // Sub items
                if !vm.items.isEmpty {
                    Section("Sub Items"){
                        ForEach(vm.items, id: \.id) { item in
                            NavigationLink(value: item) {
                                ItemBV(vm: ItemBV.ViewModel(item: item)) { _ in } onValueChange: { }
                            }
                            .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
                            
                        }
                        .onDelete(perform: vm.delete)
                        .onMove(perform: vm.move)
                    }
                    
                }
                
                // No sub item view
                if vm.items.isEmpty {
                    HStack{
                        Spacer()
                        Text("No sub item.")
                            .foregroundColor(.gray)
                        Spacer()
                    }.listRowBackground(Color(.systemGroupedBackground))
                        .listRowSeparator(Visibility.hidden)
                }
                
                // add button below the list
//                HStack{
//                    Spacer()
//                    Button{
//                        vm.addItem()
//                    } label: {
//                        Image(systemName: "plus.circle.fill" )
//                            .font(.title)
//                            .foregroundColor(.orange)
//
//                    }
//                    Spacer()
//                }.listRowBackground(Color(.systemGroupedBackground))
                
            }
            .navigationTitle(vm.navigationTitle)
            
            .navigationBarItems(
                trailing:
                    Button{
                        vm.addItem()
                    } label: {
                        Image(systemName: "plus.circle.fill" )
                            .resizable()
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                    })
            
            
//            .toolbar{EditButton()}
            .onAppear{
                vm.parentVM?.selectedItem = vm.parentItem
            }
            
            
        }
    }
}

// MARK: - Preview
struct RecursiveItemListView_Previews: PreviewProvider {
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
        
        let rootItem = ItemBindableModel(name: "Root Item", position: 0 /*, items: items*/)
        
        RecursiveItemListView(vm: RecursiveItemListView.ViewModel(parentItem: rootItem))
    }
}

