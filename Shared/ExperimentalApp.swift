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
            MainHolderV(vm: MainHolderV.ViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
//            SplitView()
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
