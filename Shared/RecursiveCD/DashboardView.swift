//
//  DashboardView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 30/07/2023.
//

import SwiftUI

// MARK: - ViewModel

extension DashboardView {
    @MainActor
    class ViewModel: ObservableObject {
        
        let moc = PersistenceController.shared.container.viewContext
        
        @Published var navigationVM = CDNavigationView.ViewModel()
        
        init() {
            let _ = ItemCRUD().addInitialItem()
            let rootItem = ItemCRUD().findBy(name: ItemCRUD.rootItemName).first
            
            //navigationVM.set(rootItem: rootItem, moc: moc)
        }
        
    }
}
// MARK: - View
struct DashboardView: View {
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationStack{
            List{
                NavigationLink {
                    CDNavigationView(vm: vm.navigationVM)
                    
                } label: {
                    Text("Manage Objects")
                        .padding(40)
                        .foregroundColor(.gray)
                }
                
                NavigationLink {
                    //
                } label: {
                    Text("Data Entry").padding(40).foregroundColor(.gray)
                }
                
                
            }.navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView(vm: DashboardView.ViewModel())
}
