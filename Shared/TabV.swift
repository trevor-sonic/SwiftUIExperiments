//
//  TabV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 17/05/2022.
//

import SwiftUI

struct TabV: View {
    
    private let colors: [Color] = [.red, .blue, .green, .orange, .gray]
   
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.pink) // custom color.
       }
    
    var body: some View {
        
        TabView {
            Group{
                ForEach(colors, id: \.self) { color in
                    ZStack{
                        color.ignoresSafeArea()
                        VStack(spacing:50){
                            Button{
                                
                            } label: {
                                Image(systemName: "face.smiling")
                                    .font(Font.system(size: 100))
                            }.font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Text("\(color.description.localizedUppercase)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }
                        
                    }
                    .tabItem {
                        Label("\(color.description.localizedUppercase)", systemImage: "dot.square.fill")
                    }
                } // forEach
            } // group
            //.ignoresSafeArea()
//            .toolbar(.visible, for: .tabBar)
//            .toolbarBackground(Color.purple, for: .tabBar)
        } //tabview
        .onAppear{
            UITabBar.appearance().backgroundColor = UIColor.black
            UITabBar.appearance().isTranslucent = false
                
        }
        .accentColor(.yellow)
        
    } // body
}

struct TabV_Previews: PreviewProvider {
    static var previews: some View {
        TabV()
    }
}
