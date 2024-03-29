//
//  CDItemView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 04/07/2023.
//

import SwiftUI



// MARK: - View
struct CDNavigationView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var vm: ViewModel
    
    
    
    
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack {
            EmptyView().disabled(vm.needUpdate)
            CDItemListView(vm: vm.getListViewModel(for: vm.rootItem?.uuidAsString ?? "x", parent: vm.rootItem))
            .environment(\.managedObjectContext, moc)
            .navigationDestination(for: Item.self) { item in
                
                let vm = vm.getListViewModel(for: item.uuidAsString, parent: item)
                
                CDItemListView(vm: vm)
                .environment(\.managedObjectContext, moc)
            }
            
        }
    }
}


// MARK: - Preview
//struct CDItemView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let rootItem = ItemBindableModel(title: "Root Item (Bindable)", position: 0)
//        CDNavigationView(vm: CDNavigationView.ViewModel(rootItem: rootItem))
//    }
//}
