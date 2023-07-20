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
        
        static var allTypes: [ValueType] { [.string, .int, .double, .date] }
        
        var description: String {
            switch self {
            case .string: return "String/Text"
            case .int: return "Integer"
            case .double: return "Double"
            case .date: return "Date"
            //default: return "*implement in ValueType"
            }
        }
        
        var asNSNumber: NSNumber {
            return NSNumber(integerLiteral: self.rawValue)
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
        let int = getAsInt() ?? 0
        return Item.ValueType(rawValue: int) ?? .string
    }
    
    /// NSNumber? -> Item.ValueType as string
    func getAsStringDescription() -> String {
        let int = getAsInt() ?? 0
        return Item.ValueType(rawValue: int)?.description ?? "unknown type"
    }
    
    /// NSNumber? -> Int?
    func getAsInt() -> Int? {
        if let _self = self {
            return Int(truncating: _self)
        }else{
            
            return nil
        }
    }
    
    /// NSNumber? -> Double?
    func getAsDouble() -> Double? {
        if let _self = self {
            return Double(truncating: _self)
        }else{
            
            return nil
        }
    }
    
    ///  Int? -> NSNumber?
    mutating func setWith(_ intValue: Int?) {
        if let intValue = intValue {
            self = intValue as NSNumber
        }else{
            self = nil
        }
    }
    
    ///  Double? -> NSNumber?
    mutating func setWith(_ doubleValue: Double?) {
        if let doubleValue = doubleValue {
            self = doubleValue as NSNumber
        }else{
            self = nil
        }
    }
}
extension Optional where Wrapped == Double {
    ///  Double? -> NSNumber?
    func getAsNSNumber() -> NSNumber? {
        self as NSNumber?
    }
}

extension Optional where Wrapped == Int {
    ///  Double? -> NSNumber?
    func getAsNSNumber() -> NSNumber? {
        self as NSNumber?
    }
}

// MARK: - Shortcuts, castings
extension Item {
    public var uuidAsString: String { return uuid.uuidString }
    
    
    /// This is for NSSet -> [Item]
    public var itemsAsArray: [Item] {
        return items.sorted { $0.position < $1.position }
    }

    public var positionAsInt: Int { Int(position) }
    
}

