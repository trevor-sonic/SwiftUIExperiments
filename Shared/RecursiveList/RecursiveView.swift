//
//  RecursiveView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import SwiftUI

struct RecursiveView: View {
    
    let items: [ItemBindableModel]
    
    init(items: [ItemBindableModel]) {
        self.items = items
    }
    
    var body: some View {
        NavigationView {
            RecursiveListView(items: items)
        }
    }
}

struct RecursiveView_Previews: PreviewProvider {
    static var previews: some View {
        
        let items = [
                    ItemBindableModel(title: "Item 1", position: 1),
                    ItemBindableModel(title: "Item 2", position: 2),
                    ItemBindableModel(title: "Item 3", position: 3)
                    ]
        
//        , items: [
//                        ItemBindableModel(name: "Item 3.1", position: 1),
//                        ItemBindableModel(name: "Item 3.2", position: 2,  items: [
//                            ItemBindableModel(name: "Item 3.2.1", position: 1),
//                            ItemBindableModel(name: "Item 3.2.2", position: 2),
//                            ItemBindableModel(name: "Item 3.2.3", position: 3)
//                        ]),
//                        ItemBindableModel(name: "Item 3.3", position: 3)
//                    ]),
//                    ItemBindableModel(name: "Item 4", position: 4)
//                ]
        
        RecursiveView(items: items)
    }
}
