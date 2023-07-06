//
//  Item_Extension.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//

import Foundation

// MARK: - Extensions

// MARK: - Enums
extension Item {
    enum ValueType: Int {
        case string, int, double, date
    }
// this is improved in extension below
//    var valueTypeAsInt: Int { return Int(truncating: valueType ?? 0) }
//    var valueTypeAsEnum: ValueType {
//        return ValueType(rawValue: valueTypeAsInt) ?? .string
//
//    }
    
}

// MARK: - Set valueType with valueType.setAs(.string) format
extension Optional where Wrapped == NSNumber {
    mutating func setAs(_ valueType: Item.ValueType) {
        self = (valueType.rawValue) as NSNumber
    }
    func getAsType() -> Item.ValueType {
        let int = Int(truncating: self ?? 0)
        return Item.ValueType(rawValue: int) ?? .string
    }
}



// MARK: - Shortcuts, castings
extension Item {
    public var uuidAsString: String? { return uuid?.uuidString }
    
    
    /// This is for NSSet -> [Item]
    public var itemsArray: [Item] {
       
        valueType.getAsType()
        valueType.setAs(.int)
        //let set = items as Set<Item>
        return items.sorted { $0.position < $1.position }
    }

    public var positionAsInt: Int { Int(position) }
    
}

