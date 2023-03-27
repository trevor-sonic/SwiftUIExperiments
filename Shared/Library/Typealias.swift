//
//  Typealias.swift
//  EvaluationManager
//
//  Created by Beydag, Duygun (Proagrica-HBE) on 13/12/2021.
//  Copyright © 2021 Proagrica-AH. All rights reserved.
//

import Foundation

// Some project wide common type aliases

/// Use for basic return closure
/// func something(complete: @escaping ClosureBasic) { }
public typealias ClosureBasic = (()->Void)

/// Use for returnig value
///  Example
///  ClosureWith<String>
///  ClosureWith<Int>
///  func something(complete: @escaping ClosureWith<String>) { }
public typealias ClosureWith<T> = ((T)->Void)


public typealias ClosureResult<T> = ((Result<T, Error>)->Void)
