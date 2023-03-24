//
//  ItemData.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 24/03/2023.
//

import Foundation

struct ItemData: Identifiable {
    let id = UUID()
    let name: String?
    
    
    var items: [ItemData] = []
    
}

// MARK: - computed
extension ItemData {
    var nameWrapped: String { name ?? "" }
}


// MARK: - Mocks
extension ItemData {
    
    static let mock: [ItemData] = [
        ItemData(name: "First Item"),
        ItemData(name: "Second Item"),
        ItemData(name: "Third Item")
        
    ]
    
    
    static let mockMiddle: [ItemData] = [
        ItemData(name: "Middle Item 1"),
        ItemData(name: "Middle Item 2"),
        ItemData(name: "Middle Item 3", items: [
            ItemData(name: "Child One"),
            ItemData(name: "Child Two"),
            ItemData(name: "Child Three"),
            ItemData(name: "Child Four"),
            ItemData(name: "Child Five")
        ])
        
    ]
}
