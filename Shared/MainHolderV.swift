//
//  MainHolderV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import SwiftUI

struct MainHolderV: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.black) // custom color.
    }
    
    var body: some View {
        TabView{
            
            // View 1
            MultiListV(vm: MultiListV.ViewModel())
                //.ignoresSafeArea()
                .tabItem {
                    Label("Lists".uppercased(), systemImage: "list.bullet")
                }
            
            
            // View 2
            ZStack{
                Color.purple
                Text("Seq".uppercased()).font(.title).foregroundColor(.white)
            }.ignoresSafeArea()
                .tabItem {
                    Label("Seq".uppercased(), systemImage: "chart.bar.doc.horizontal")
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
        MainHolderV()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone Portrait")
            //.preferredColorScheme(.dark)
        
        MainHolderV()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone Landscape")
            .previewInterfaceOrientation(.landscapeLeft)
        
        MainHolderV()
            .previewInterfaceOrientation(.portrait)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad Portrait")
        
        MainHolderV()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad Landscape")
    }
}
