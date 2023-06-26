//
//  BVar.swift
//  Common use Bindable Variable
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/02/2023.
//  Copyright © 2023 Proagrica-AH. All rights reserved.
//
//  Source: https://github.com/trevor-sonic/DJWBindableVar/blob/master/Sources/DJWBindableVar/BVar.swift


import Foundation


// MARK: - Bindable example with enum
class Examples{
    
    func something(){
        let bv1: BVar<Int> = BVar(0)
        let bv2: BVar<Int> = BVar(0)
        
        bv1.bind(.ui, andSet: true) { value in
            print(value)
        }
        
        bv2.bind(.ui, andSet: true) { value in
            print(value)
        }
        
        
        bv1.bBind(.slave, andSet: true, to: bv2)
        bv1.bBind(.slave, andSet: true, to: bv2, toBranch: .master)
        
    }
}
public enum Branch{
    case master, parent
    
    /// ui related bindings
    case ui, ui2, ui3
    
    /// audio related bindings
    case audio, audio2
    
    /// database
    case db
    
    /// to connect other main
    case slave, child
    
    /// for any other extra needs
    case extra, extra2, extra3
    
    /// use these for debugging
    case debug, debug2
}

/// Dynamic Bindable Variable
open class BVar<T:Equatable>{
    
    public typealias VarHandler    = (T) -> Void
    private var _value: T
    

    private var listeners:[Branch:VarHandler?] = [:]
    
    #if DEBUG
    private var connections:[Branch:String?] = [:]
    #endif
    
    // MARK: -  New version with enum
    public func bind( _ branch:Branch, andSet:Bool, _ listener: VarHandler?, callingMethod: String = #function) {
        listeners[branch] = listener
        #if DEBUG
        connections[branch] = callingMethod//Thread.callStackSymbols.first?.debugDescription
        #endif
        if andSet { listener?(value) }
    }

    // MARK: - Bidirectional binding with enum
    /// Just binding is not making difference but bindAndSet need some care cause one is setting the other
    /// while binding so one must be master other slave
    public func bBind( _ branch:Branch, andSet:Bool, to bvar:BVar<T>, toBranch:Branch = .master) {
        
        bvar.bind(toBranch, andSet: false) { [weak self] value in
            self?.value = value
        }
        bind(branch, andSet: andSet) { value in
            bvar.value = value
        }
    }
    
    
    
    
    // MARK: - Init
    /// Initialiser of the dynamic variable
    public init (_ value: T) { self._value = value }
    // MARK: - Deinit
    deinit{
        unbindAll()
    }
    /// Unbind all variables
    private func unbindAll(){
        for (branch, _) in listeners{
            unbind(branch)
        }
    }
    /// if branch is not defined all branches will be disconnected
    public func unbind(_ branch:Branch? = nil){
        if let branch = branch {
            listeners[branch] = nil
            listeners.removeValue(forKey: branch)
            #if DEBUG
            connections.removeValue(forKey: branch)
            #endif
        }else{
            unbindAll()
        }
    }
    // MARK: - Set
    /// Value of the bond variable.
    public var value: T {
        set {
            if self._value != newValue {
                self._value = newValue
                sendNotification()
            }
        }
        get{
            return _value
        }
    }
    /// Set without sending any notification
    public func silentSet(_ value:T){
        self._value = value
    }
    
    /// Set without sending any notification
    public func forceSet(_ value:T){
        self._value = value
        sendNotification()
    }
    
    /// Returns bound branches.
    public var bondBranches:[Branch]{
        let desc = listeners.map { key, value -> Branch in
            return key
        }
        return desc
    }
    #if DEBUG
    public var bondConnections:[String]{
        let desc = listeners.compactMap { key, value -> String in
            return "\(key): \(String(describing: connections[key]! ?? ""))"
        }
        return desc
    }
    
    #endif
    private func sendNotification(){
        for (_, listener) in listeners{
            listener?(_value)
        }
    }
}
