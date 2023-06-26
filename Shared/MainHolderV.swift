//
//  MainHolderV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI

extension MainHolderV {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var multiListVM = MultiListV.ViewModel()
        
        
        init() {
            ItemCRUD().addMockData() // This adds 5 record if it is not added before.
        }
        
        func setSelected(listIndex: Int, selectedItem: ItemData?){
            
            if listIndex == 1 {
                multiListVM.list3vm.items = selectedItem?.items ?? []
            }
            
        }
        
    }
}


struct MainHolderV: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        
        self.vm = vm
        
        UITabBar.appearance().barTintColor = UIColor(Color.black) // custom color.
        
        
    }
    
    var body: some View {
        TabView{
            
            // View 1
            MultiListV(vm: vm.multiListVM){ (listIndex, itemData) in
                vm.setSelected(listIndex: listIndex, selectedItem: itemData)
            }
            .tabItem {
                Label("Lists".uppercased(), systemImage: "list.bullet")
            }
            
            
            // View 2
            ZStack{
                Color.purple
                Text("Screen".uppercased()).font(.title).foregroundColor(.white)
            }.ignoresSafeArea()
                .tabItem {
                    Label("Screen".uppercased(), systemImage: "chart.bar.doc.horizontal")
                }
        }
        .accentColor(.white)
        .onAppear{
            UITabBar.appearance().backgroundColor = UIColor.black
            UITabBar.appearance().isTranslucent = true
            
        }
        
    }
}

struct MainHolderV_Previews: PreviewProvider {
    static var previews: some View {
        MainHolderV(vm: MainHolderV.ViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone Portrait")
        //.preferredColorScheme(.dark)
        
        MainHolderV(vm: MainHolderV.ViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone Landscape")
            .previewInterfaceOrientation(.landscapeLeft)
        
        MainHolderV(vm: MainHolderV.ViewModel())
            .previewInterfaceOrientation(.portrait)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad Portrait")
        
        MainHolderV(vm: MainHolderV.ViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad Landscape")
    }
}
