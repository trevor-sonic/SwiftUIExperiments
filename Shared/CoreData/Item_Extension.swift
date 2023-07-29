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
    enum ValueType: Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.rawValue)
        }
        case undefined, string, int, double, date, array
        case object(_ name: String?)
        
        static var allTypes: [ValueType] { [.undefined, .string, .int, .double, .date, .object(nil), .array] }
        
        static var arrayTypes: [ValueType] { [.string, .int, .double, .date] }
        
        
        var description: String {
            switch self {
            case .undefined: return "Undefined"
            case .string: return "String/Text"
            case .int: return "Integer"
            case .double: return "Double"
            case .date: return "Date"
            case .object: return "Object"
            case .array: return "Array"
            //default: return "*implement in ValueType"
            }
        }
        
        var rawValue: Int {
            switch self {
            case .undefined: return 0
            case .string: return 1
            case .int: return 2
            case .double: return 3
            case .date: return 4
            case .object: return 5
            case .array: return 6
            }
        }
        
        init(rawValue: Int, name: String? = nil){
            switch rawValue {
            case 0: self = .undefined
            case 1: self = .string
            case 2: self = .int
            case 3: self = .double
            case 4: self = .date
            case 5: self = .object(name)
            case 6: self = .array
            default: self = .undefined
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
extension Item {
    
    func setValueType(_ valueType: Item.ValueType) {
        self.valueType = (valueType.rawValue) as NSNumber
    }
    
    
    /// NSNumber? -> Item.ValueType
    func getValueType() -> Item.ValueType {
        let int = getAsInt()
        return Item.ValueType(rawValue: int) ?? .undefined
    }
    
    /// NSNumber? -> Item.ValueType as string
    func getValueTypeAsStringDescription() -> String {
        let int = getAsInt()
        return (Item.ValueType(rawValue: int) ?? .undefined).description
    }
    func getAsInt() -> Int {
        return Int(truncating: valueType)
    }
}
extension Optional where Wrapped == NSNumber {

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

// MARK: - Copy Object properties
//extension Item {
//    func copyFrom(object: Item){
//        self.title = object.title
//        self.name = object.name
//        //self.valueType = object.valueType
//    }
//}
