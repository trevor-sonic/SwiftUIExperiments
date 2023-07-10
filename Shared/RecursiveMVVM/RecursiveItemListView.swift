//
//  RecursiveItemListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI



// MARK: - View
struct RecursiveItemListView: View {
    
    @ObservedObject var vm: ViewModel
    
    var detailsVM: RecursiveItemDetailsView.ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        let parentItem = vm.parentItem ?? ItemBindableModel(title: "Parent Item?", position: 0)
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
            ItemBindableModel(title: "Item 1", position: 1),
            ItemBindableModel(title: "Item 2", position: 2),
            ItemBindableModel(title: "Item 3", position: 3)
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
        
        let rootItem = ItemBindableModel(title: "Root Item", position: 0 /*, items: items*/)
        
        RecursiveItemListView(vm: RecursiveItemListView.ViewModel(parentItem: rootItem))
    }
}

