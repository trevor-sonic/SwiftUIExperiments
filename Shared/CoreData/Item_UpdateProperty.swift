//
//  Item_UpdateProperty.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 01/08/2023.
//

import Foundation

extension Item {
    enum Property {
        case name(String)
        case title(String)
        case valueDate, valueDouble, valueInt, valueString, valueType, valueArray, valueObject
    }
}
