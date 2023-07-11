//
//  CDItemListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI



// MARK: - View
struct CDItemListView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm: ViewModel
    
    var detailsVM: CDItemDetailsView.ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        let parentItem = vm.parentItem
        detailsVM = CDItemDetailsView.ViewModel(item: parentItem)
    }
    
    var body: some View {
        VStack{
            List{
                
                // Details View
                CDItemDetailsView(vm: detailsVM)
                    .environment(\.managedObjectContext, moc)
                
                // Sub items
                if !vm.items.isEmpty {
                    Section("Sub Items"){
                        ForEach(vm.items, id: \.id) { item in
                            NavigationLink(value: item) {
                                CDItemView(vm: CDItemView.ViewModel(item: item))
                                    .environment(\.managedObjectContext, moc)
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
//struct CDItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let items = [
//            ItemBindableModel(title: "Item 1", position: 1),
//            ItemBindableModel(title: "Item 2", position: 2),
//            ItemBindableModel(title: "Item 3", position: 3)
//            ]
//
//        
//        let rootItem = ItemBindableModel(title: "Root Item", position: 0 /*, items: items*/)
//        
//        CDItemListView(vm: CDItemListView.ViewModel(parentItem: rootItem))
//    }
//}

