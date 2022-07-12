//
//  SwipeV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 17/05/2022.
//

import SwiftUI

struct SwipeV: View {
    
    private let colors: [Color] = [.red, .blue, .green, .orange, .gray]
    @State internal var lock:Bool = false
    var body: some View {
        VStack{
            TabView {
                ForEach(colors, id: \.self) { color in
                    ZStack{
                        color
                        VStack(spacing:50){
                            Button{
                                lock.toggle()
                            } label: {
                                Image(systemName: lock ? "lock":"lock.open")
                            }.font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Text("\(color.description)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }
                    }.gesture(lock ? DragGesture() : nil)  // blocks TabView gesture
                }
            } //tabview
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .cornerRadius(30)
            .padding(10)
        }
    }
}

struct SwipeV_Previews: PreviewProvider {
    static var previews: some View {
        SwipeV()
    }
}
