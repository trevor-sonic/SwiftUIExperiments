//
//  Item_Extension.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//

import Foundation

// MARK: - Extensions
extension Item {
    public var uuidAsString: String? { return uuid?.uuidString }
    
    /// This is for NSSet -> [Item]
    public var itemsArray: [Item] {
        //let set = items as Set<Item>
        return items.sorted { $0.position < $1.position }
    }

    public var positionAsInt: Int { Int(position) }
    
}
