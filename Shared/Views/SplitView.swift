//
//  SplitView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 11/04/2023.
//

import SwiftUI

struct SplitView: View {
    var body: some View {
        NavigationView{
            
            // side bar, list
            List(1...3, id:\.self){ n in
                Text("Side \(n)")
            }
            
            // centre
            List(1...5, id:\.self){ n in
                Text("Centre \(n)")
            }
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            .previewDisplayName("iPad Landscape")
    }
}
