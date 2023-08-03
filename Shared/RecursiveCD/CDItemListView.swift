//
//  CDItemListView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI



// MARK: - View
struct CDItemListView: View {
    
    @ObservedObject var vm: ViewModel
    
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    
    var body: some View {
        VStack{
            //Toggle("NeedUpdate", isOn: $needUpdate)
            EmptyView().disabled(vm.needUpdate)
//            List(selection: $vm.selectedItem){
            List{
                
                if let parentItem = vm.parentItem {
                    // Details View
                    CDItemDetailsView(vm: vm.detailsVM)
                }
                
                // Sub items
                if !vm.items.isEmpty {
                    Section("Sub Items"){
                        ForEach(vm.items, id: \.id) { item in
                            NavigationLink(value: item) {
                                let vm = TextInputView.ViewModel(text: "\(item.positionAsInt): \(item.title ?? "" )")
                                TextInputView(vm: vm)
                            }
                            .listRowBackground(vm.selectedItem == item ? Color(.systemFill) : nil)
                            
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
                
                
            }
            .navigationTitle(vm.navigationTitle)
            
            .navigationBarItems(
                trailing:
                    HStack(spacing: 16){
//                        Button{
//                            // refresh
//                            vm.needUpdate.toggle()
//                        } label: {
//                            Image(systemName: "arrow.clockwise" )
//                                .resizable()
//                                .font(.title2)
//                                .foregroundColor(.accentColor)
//                            
//                        }
                        Button{
                            vm.checkAddItemType()
                        } label: {
                            Image(systemName: "plus.circle.fill" )
                                .resizable()
                                .font(.title2)
                                .foregroundColor(.accentColor)
                            
                        }
                    }
                
            )
            .sheet(isPresented: $vm.showingSheet) {
                SheetView(vm: vm.addSheetVM )
                    }
            .onAppear{
                vm.loadItem()
                vm.parentVM?.selectedItem = vm.parentItem
            }
            
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var vm: ArrayTypesListView.ViewModel
    
    var body: some View {
        VStack{
            ArrayTypesListView(vm: vm)
            Button("Press to dismiss") {
                dismiss()
            }
            .font(.body)
            .padding()
        }.background(.black)
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

