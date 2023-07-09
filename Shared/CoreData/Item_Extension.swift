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
        
        var description: String {
            switch self {
            case .string: return "String value"
            case .int: return "Integer"
            default: return "*implement in ValueType"
            }
        }
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
    
    /// NSNumber? -> Item.ValueType
    func getAsType() -> Item.ValueType {
        let int = Int(truncating: self ?? 0)
        return Item.ValueType(rawValue: int) ?? .string
    }
    
    /// NSNumber? -> Item.ValueType as string
    func getAsStringDescription() -> Item.ValueType {
        let int = Int(truncating: self ?? 0)
        return Item.ValueType(rawValue: int) ?? .string
    }
    
    /// NSNumber? -> Int?
    func getAsInt() -> Int? {
        if let _self = self {
            return Int(truncating: _self)
        }else{
            return nil
        }
    }
}



// MARK: - Shortcuts, castings
extension Item {
    public var uuidAsString: String { return uuid.uuidString }
    
    
    /// This is for NSSet -> [Item]
    public var itemsArray: [Item] {
       
        valueType.getAsType()
        valueType.setAs(.int)
        //let set = items as Set<Item>
        return items.sorted { $0.position < $1.position }
    }

    public var positionAsInt: Int { Int(position) }
    
}

