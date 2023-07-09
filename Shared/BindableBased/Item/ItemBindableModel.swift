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
    let title: BVar<String> = BVar("")
    
    let valueType: BVar<Item.ValueType> = BVar(.string)
    let name: BVar<String> = BVar("")
    let valueString: BVar<String> = BVar("")
    let valueInt: BVar<Int?> = BVar(nil)
    
    let position: BVar<Int> = BVar(0)

    // MARK: - Relationships
    var parent: BVar<ItemBindableModel?> = BVar(nil)
    let items: BVar<[ItemBindableModel]> = BVar([])
    
    // To compare changes to determine add/remove/move actions
    let backupItems: BVar<[ItemBindableModel]> = BVar([])
    
    // MARK: - init
    /// Use this for real CD updates
    init(item: Item?, moc: NSManagedObjectContext?) {
        self.item = item
        self.moc = moc

        // set bindables
        if let item = item {
            id = item.uuid
            
            title.value = item.title ?? ""
            name.value = item.name ?? ""
            
            valueType.value = item.valueType.getAsType()
            valueString.value = item.valueString ?? ""
            valueInt.value = item.valueInt.getAsInt()
            // implement double etc...
            
            position.value = item.positionAsInt
            ///parent = ItemBindableModel(item: item.parent, moc: moc)
            
            let sorted = item.itemsArray.sorted{$0.position < $1.position}
            items.value = sorted.map { item in
                return ItemBindableModel(item: item, moc: moc)
            }
            
            // without this every time app lunch creates a new child
            backupItems.value = items.value
        }

        // bind and listen
        bind()
        
        
        //addListeners()
        //changeWithInterval()
    }
    
    /// Use this for UI design and debugging
    init(title: String, position: Int, parent: ItemBindableModel? = nil, uuid: UUID  = UUID()){
        self.item = nil
        self.moc = PersistenceController.shared.container.viewContext
        
        // item properties
        self.id = uuid
        self.title.value = title
        self.position.value = position
        self.items.value = [] //items
        self.parent.value = parent
        
        bind()
        
        // Add into CoreData
        if let parent = parent,
            let parentCDItem = ItemCRUD().findBy(uuid: parent.id.uuidString) {
            
            let newItem = ItemCRUD().getNewItem(parent: parentCDItem)
            
            newItem.uuid = self.id
            newItem.title = self.title.value
            newItem.name = self.name.value
            newItem.position = Int64(self.position.value)
            
            self.item = newItem
            
            ItemCRUD().save()
        }
        
        
        //changeWithInterval()
    }
    
    // For testing change the value with 3 sec. interval
    func changeWithInterval(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [weak self] in
            
            self?.title.value = ["ABC", "DEF", "GHI", "JKL", "MNO"].randomElement()!
            
            self?.changeWithInterval()
        }
        
    }
    
    
    
    // MARK: - Bind: Listen received changes for CoreData
    /// Bind the BindableVar to Core Data object. Update CD with UI changes
    func bind(){
        // title listener and updated
        title.bind(.master, andSet: true) { [weak self] value in
            
            
                print("Update from UI->CD bind() -> name: \(String(describing: value)) in ItemModel")
            
                
            
        }
        
        name.bind(.master, andSet: true) { [weak self] value in
            print("Update from UI->Debug bind() -> name: \(self?.parent.value?.name.value) in ItemModel")
        }
        valueType.bind(.master, andSet: true) { [weak self] value in
            print("Update from UI->Debug bind() -> valueType: \(self?.parent.value?.valueType.value) in ItemModel")
        }
        
        valueString.bind(.master, andSet: true) { [weak self] value in
            print("Update from UI->Debug bind() -> valueString: \(self?.parent.value?.valueString.value) in ItemModel")
        }
        
        valueInt.bind(.master, andSet: true) { [weak self] value in
            print("Update from UI->CD bind() -> valueInt: \(self?.parent.value?.valueInt.value) in ItemModel")
        }
        
        parent.bind(.master, andSet: true) { [weak self] value in
            print("Update from UI->CD bind() -> parent: \(String(describing: value?.title.value))")
            
            print("parent.items.value.count: \(value?.items.value.count)")
            
            
            if let _self = self,
            let parent = _self.parent.value,
            !parent.items.value.contains(_self){
                
                parent.items.value.append(_self)
                
            }

        }
        
        // Add/Remove (detection)
        items.bind(.master, andSet: true) { [weak self] items in
            if let _self = self {
               
                
                let changes = Set(items).symmetricDifference(_self.backupItems.value)
                
                
                if items.count > _self.backupItems.value.count {
                    print("❇️ Added new item + CD")
                    _self.fixPositions()
                    
                    
                    changes.forEach { item in
                        print("+ Added: \(String(describing: item.title.value))")
                        
//                        // Add into CoreData
//                        if let _ = _self.item,
//                            let parentItem = ItemCRUD().findBy(uuid: _self.id.uuidString){
//
//                            let newItem = ItemCRUD().getNewItem(parent: parentItem)
//
//                            newItem.uuid = item.id
//                            newItem.title = item.title.value
//                            newItem.name = item.name.value
//
//                        }
                        
                    }
                    
                    if let _ = _self.item{ ItemCRUD().save() }
                    
                    
                    
                } else if items.count < _self.backupItems.value.count {
                    print("❌ Deleted an item")
                    _self.fixPositions()
                    
                    changes.forEach { item in
                        print("- Deleted: \(String(describing: item.title.value))")
                        
                        // Delete from CoreData
                        if let _ = _self.item,
                           let itemToDelete = ItemCRUD().findBy(uuid: item.id.uuidString){
                            ItemCRUD().delete(item: itemToDelete)
                        }
                
                    }
                    if let _ = _self.item{ ItemCRUD().save() }
                    
                    
                } else if !_self.isPositionsCorrect() {
                    print("↕️ * Re-ordered an item")
                    _self.fixPositions()
                }
                
                print("UI->CD bind() -> count: \(String(describing: _self.parent.value?.items.value.count)) in ItemModel")
                print("In parent: \(String(describing: _self.parent.value?.title.value))\n")
                
                // backup old values
                _self.backupItems.value = items
                
                
            }
        }
    }

    
    private func isPositionsCorrect() -> Bool {
        if let _ =  items.value.enumerated().first (where: { (i, item) in
            item.position.value != i
        }) {
            return false
        }
        return true
    }
    private func fixPositions(){
        guard !isPositionsCorrect() else {return}
        for i in items.value.indices {
            items.value[i].position.value = i
            
            if let oldPos = items.value[i].item?.position, oldPos != i {
                items.value[i].item?.position = Int64(i)
                print("Item -> \(items.value[i].item?.position)")
            }
            
            
           
        }
        if let _ = item{ ItemCRUD().save() }
        
    }
    var isListenerAdded = false
    // MARK: -  Add listeners - (this listeners must be removed otherwise creates instability in the core data)
    func addListeners(){
        // Add Observer
        if let moc = moc, !isListenerAdded {
            isListenerAdded = true
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
                   let newName = item.title,
                    title.value != newName {
                    title.value = newName
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
extension ItemBindableModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title.value)
        hasher.combine(position.value)
        }
}
