//
//  ItemBindableModel.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 26/06/2023.
//

import Foundation
import CoreData



// MARK: - ItemBindableModel
/// Bindable Model between ManagedQuestion and ViewModels
class ItemBindableModel: Identifiable {

    // MARK: - input vars
    var item: Item?
    var moc: NSManagedObjectContext?
    
    // Unique id for Identifiable implementation
    var id = UUID()
    
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
            id = item.uuid!
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
        //changeWithInterval()
    }
    
    // For testing change the value with 3 sec. interval
    func changeWithInterval(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [weak self] in
            
            self?.name.value = ["ABC", "DEF"].randomElement()!
            
            self?.changeWithInterval()
        }
        
    }
    
    
    
    // MARK: - Bind: Listen received changes
    /// Bind the BindableVat to Core Data object. Update CD with UI changes
    func bind(){
        name.bind(.master, andSet: true) { [weak self] value in
            if let _self = self {
                if let item = _self.item, item.name != value {
                    print("Update from UI->CD bind() -> name: \(String(describing: value)) in ItemModel")
                    item.name = value
                    ItemCRUD().update(item: item)
                }
                
                
            }
        }
    }
    /// Bind to the debug object for testing
    func bindForUIDebug(){
        name.bind(.debug, andSet: true) { value in
            print("Update from UI->Debug bind() -> name: \(String(describing: value)) in ItemModel")
        }
    }
    
    var isListennerAdded = false
    // MARK: -  Add listeners - (this listeners must be removed otherwise creates instability in the core data)
    func addListeners(){
        // Add Observer
        if let moc = moc, !isListennerAdded {
            isListennerAdded = true
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
                if let item = update as? Item,
                    item.uuid == id,
                   let newName = item.name,
                    name.value != newName {
                    name.value = newName
                }
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

extension ItemBindableModel: Equatable {
    static func == (lhs: ItemBindableModel, rhs: ItemBindableModel) -> Bool {
        lhs.id == rhs.id
    }
    
    
}
