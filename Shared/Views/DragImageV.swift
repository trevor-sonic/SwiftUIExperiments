//
//  DragImageV.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 17/05/2022.
//

import SwiftUI

struct DragImageV: View {
    
    @State private var dragOffset = CGSize.zero
    // this example didn't work
    var body: some View {
        VStack {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 100))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            dragOffset = .zero
                        }
                )
            
            
        }
    }
}

struct DragImageV_Previews: PreviewProvider {
    static var previews: some View {
        DragImageV()
    }
}
