//
//  ItemModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 26/06/2023.
//

import Foundation
import CoreData


// MARK: - QuestionModel
/// Bindable Model between ManagedQuestion and ViewModels
class ItemModel {

    // MARK: - input vars
    var item: Item?
    var moc: NSManagedObjectContext?
    
    // MARK: - Bindable vars
    let name: BVar<String> = BVar("")
    let position: BVar<Int> = BVar(0)

    
    
    // MARK: - init
    /// Use this for real CD updates
    init(item: Item?, moc: NSManagedObjectContext?) {
        self.item = item
        self.moc = moc

        // set bindables
        if let item = item {
            name.value = item.name ?? "No-Name"
            position.value = item.positionAsInt
        }

        // bind and listen
        bind()
        addListeners()
    }
    
    /// Use this for UI design and debugging
    init(name: String, position: Int){
        self.item = nil
        self.moc = nil
        
        self.name.value = name
        self.position.value = position
        
        bindForUIDebug()
    }
    
    
    
    // MARK: - Bind: Listen received changes
    /// Bind to the real core data object. Update CD with UI changes
    func bind(){
        name.bind(.master, andSet: true) { [weak self] value in
            if let _self = self {
                if let item = _self.item, item.name != value {
                    print("bind() -> name: \(String(describing: value))")
                    item.name = value
                    // ? ItemCRUD().update(question: question)
                }
            }
        }
    }
    /// Bind to the debug object for testing
    func bindForUIDebug(){
        name.bind(.debug, andSet: true) { [weak self] value in
            print("bind() -> Debug: \(String(describing: value))")
        }
    }
    
    // MARK: -  Add listeners - (this listeners must be removed otherwise creates instability in the core data)
    func addListeners(){
        // Add Observer
        if let moc = moc {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: moc)
            notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSNotification.Name.NSManagedObjectContextWillSave, object: moc)
            notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        }
    }
    
    // MARK: - Notification Handling
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("--- INSERTS ---")
            print(inserts)
            print("+++++++++++++++")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("--- UPDATES ---")
            for update in updates {
                print(update.changedValues())
            }
            print("+++++++++++++++")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            print("--- DELETES ---")
            print(deletes)
            print("+++++++++++++++")
        }
    }
    @objc func managedObjectContextWillSave(notification: NSNotification) {
        print("⚠️ Implement managedObjectContextWillSave")
    }
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        print("⚠️ Implement managedObjectContextDidSave")
    }
}


