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
            
            
         
            
            
            // MARK: -  To run 1 List with bindable vars and Core Data event listeners
//            let itemListBM = ItemListBM()
//            let items = itemListBM.fetchAllItems()
//            ItemListBV(vm: ItemListBV.ViewModel(items: items)) { _ in }
            
            // MARK: -  To run 2 List with bindable vars and Core Data event listeners
//            let mm = MultiListBModel()
//            MultiListBV(listVM1: ItemListBV.ViewModel(items: mm.items1), listVM2: ItemListBV.ViewModel(items: mm.items2))
            
            
            // MARK: - Recursive List view with bindable hierarchical data
//            let items = [
//                        ItemBindableModel(title: "Item 1", position: 1),
//                        ItemBindableModel(title: "Item 2", position: 2),
//                        ItemBindableModel(title: "Item 3", position: 3, items: [
//                            ItemBindableModel(title: "Item 3.1", position: 1),
//                            ItemBindableModel(title: "Item 3.2", position: 2,  items: [
//                                ItemBindableModel(title: "Item 3.2.1", position: 1),
//                                ItemBindableModel(title: "Item 3.2.2", position: 2),
//                                ItemBindableModel(title: "Item 3.2.3", position: 3)
//                            ]),
//                            ItemBindableModel(title: "Item 3.3", position: 3)
//                        ]),
//                        ItemBindableModel(title: "Item 4", position: 4)
//                    ]
//
//                    RecursiveView(items: items)
            
            // MARK: - Recursive hierarchical Core Data view
            
//            let items3 = [
//                ItemBindableModel(title: "Item 3.2.1", position: 1),
//                ItemBindableModel(title: "Item 3.2.2", position: 2),
//                ItemBindableModel(title: "Item 3.2.3", position: 3)
//            ]
//
//            var items2 = [
//                ItemBindableModel(title: "Item 3.1", position: 1),
//                ItemBindableModel(title: "Item 3.2", position: 2,  items: items3),
//                ItemBindableModel(title: "Item 3.3", position: 3)
//            ]
//
//            let items1 = [
//                ItemBindableModel(title: "Item 1", position: 1),
//                ItemBindableModel(title: "Item 2", position: 2),
//                ItemBindableModel(title: "Item 3", position: 3, items: items2),
//                ItemBindableModel(title: "Item 4", position: 4)
//            ]
//
//            items2.enumerated().forEach({ (i,item) in
//                item[i].parent = items1[2]
//            })
//
//            let items = items1
            
            
            // MARK: - RecursiveCDView launcher
//            let itemListBM = ItemListBM()
//            let items = itemListBM.fetchAllItems()
//            RecursiveCDView(vm: RecursiveCDListView.ViewModel(items: items))
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            
            // MARK: - RecursiveItemView launcher
            /*let rootItem = ItemBindableModel(title: "Root Item (Bindable)", position: 0)
            
            let _ = ItemBindableModel(title: "Child 1 (Bindable)", position: 0, parent: rootItem)
            let child2 = ItemBindableModel(title: "Child 2 (Bindable)", position: 1, parent: rootItem)
            let _ = ItemBindableModel(title: "Child 3 (Bindable)", position: 2, parent: rootItem)
            
            
            let _ = ItemBindableModel(title: "Child 2.A (Bindable)", position: 0, parent: child2)
            let _ = ItemBindableModel(title: "Child 2.B (Bindable)", position: 1, parent: child2)
            let _ = ItemBindableModel(title: "Child 2.C (Bindable)", position: 2, parent: child2)
           */
            
            
            // MARK: - Recursive MVVM launcher
            /*let _ = ItemCRUD().addInitialItem()
            let rootItemCD = ItemCRUD().findBy(name: ItemCRUD.rootItemName).first
            let rootItem = ItemBindableModel(item: rootItemCD, moc: persistenceController.container.viewContext)
            
            
            RecursiveItemView(vm: RecursiveItemView.ViewModel(rootItem: rootItem))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            */
            
            
            // MARK: - CDNavigation Launcher
            
            let _ = ItemCRUD().addInitialItem()
            let rootItem = ItemCRUD().findBy(name: ItemCRUD.rootItemName).first
            let moc = PersistenceController.shared.container.viewContext
            let vm = CDNavigationView.ViewModel(rootItem: rootItem, moc: moc)
            CDNavigationView(vm: vm)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            
            
//            SplitView()
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
