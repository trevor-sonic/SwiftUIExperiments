//
//  ExperimentalApp.swift
//  Shared
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 17/05/2022.
//

import SwiftUI

@main
struct ExperimentalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
//            DragImageV()
//            SwipeV()
//            TabV()
            
            
//            MainHolderV(vm: MainHolderV.ViewModel())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            /*List{
                ItemBV(vm: ItemBV.ViewModel(
                    item: ItemBindableModel(name: "Bindable Name",
                                    position: 5)),
                       onSelect: { _ in },
                       onValueChange: {})
            }
            */
            
            
            
            
//            let itemListBM = ItemListBM()
//            let items = itemListBM.fetchAllItems()
//            ItemListBV(vm: ItemListBV.ViewModel(items: items)) { _ in }
            
            
            let mm = MultiListBModel()
            MultiListBV(listVM1: ItemListBV.ViewModel(items: mm.items1), listVM2: ItemListBV.ViewModel(items: mm.items2))
            
            
            
//            SplitView()
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
