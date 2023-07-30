//
//  ItemCRUD.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//

import Foundation

class ItemCRUD: BaseCRUD {
    
    // MARK: - (C)reate
    func getNewItem(name: String? = nil, parent: Item?) -> Item {
        let e = Item(context: moc)
        e.uuid = UUID()
        e.title = name ?? "An Item"
        e.createdAt = Date()
        e.position = 0
        e.valueString = ""
        e.valueType = Item.ValueType.undefined.asNSNumber
        
        // relationship
        if let parent = parent {
            e.parent = parent
            //parent.addToItems(e)
            
            parent.items.insert(e)
        }
        
        return e
    }
    
    func getItemLike(original: Item, parent: Item?) -> Item {
        let e = Item(context: moc)
        e.uuid = UUID()
        e.title = original.title
        e.name = original.name
        e.createdAt = Date()
        e.position = original.position
        e.valueString = ""
        e.valueType = original.valueType
        
        // relationship
        if let parent = parent {
            e.parent = parent
            parent.addToItems(e)
        }
        
        original.itemsAsArray.forEach { child in
            let new = getItemLike(original: child, parent: original)
            e.addToItems(new)
        }
        
        return e
    }
    
    // MARK: - (R)ead
    
    // find first item of the path chain in the DB
    private func getRootItem(pathArray:[String]) -> Item? {
        
        if pathArray.count > 0,
           let first = pathArray.first,
           let parentItem = findBy(name: first).first{
            return parentItem
        }
        return nil
    }
    // convert path string to an array
    private func pathArray(path: String) -> [String] {
        let pathArray:[String] = path.split(separator: ".").map{String($0)}
        if pathArray.isEmpty { return [] }
        return pathArray
    }
    
    /// Get the last item of the path
    func getItem(path: String, fromItem: Item? = nil) -> Item? {
        let pathArray = pathArray(path: path)
        return getItem(pathArray: pathArray, fromItem: fromItem)
    }
    
    /// Get the last item of the pathArray
    func getItem(pathArray: [String], fromItem: Item? = nil) -> Item? {
        guard let rootItem = fromItem ?? getRootItem(pathArray: pathArray) else { return nil }
        
        if pathArray.count == 1 {
            return rootItem
        }else{
            return findItemUnderParent(parentItem: rootItem, pathArray:pathArray)
        }
    }
    
    /// Get items of the last item of the path
    func getItems(path: String, fromItem: Item? = nil) -> [Item] {
        let pathArray = pathArray(path: path)
        return getItems(pathArray: pathArray, fromItem: fromItem)
    }
    
    /// Get items of the last item of the pathArray
    func getItems(pathArray: [String], fromItem: Item? = nil) -> [Item] {
        guard let rootItem = fromItem ?? getRootItem(pathArray: pathArray) else { return [] }
        
        if pathArray.count == 1 {
            return rootItem.itemsAsArray
        }else{
            if let lastItemInChain = findItemUnderParent(parentItem: rootItem, pathArray:pathArray){
                return lastItemInChain.itemsAsArray
            }else{
                return []
            }
        }
    }
    private func findItemUnderParent(parentItem: Item, pathArray:[String], level: Int = 1) -> Item? {
    
        // object or variable
        if let found = parentItem.itemsAsArray.first(where: { child in
            child.name == pathArray[level]
        }){
            print("👉🏻 found.name: \(String(describing: found.name))")
            if level == pathArray.indices.last {
                return found
            }else{
                return findItemUnderParent(parentItem: found, pathArray: pathArray, level: level + 1)
            }
            
        }
        return nil
    }
    
    
    
    func findAll()->[Item]{
        let fetchRequest = Item.fetchRequest()
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects.sorted { $0.position < $1.position }
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return []
        }
    }
    func findBy(name: String) -> [Item] {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name == %@", name
        )
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects.sorted { $0.position < $1.position }
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return []
        }
    }
    
    /// Return an Object by name master/instance
    func findObject(name: String, isMasterObject: Bool) -> Item? {
        
        let valueString = isMasterObject ? "master":""
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name == %@ AND valueType == %i AND valueObject == %@", name, Item.ValueType.object(nil).rawValue, valueString
        )

        fetchRequest.fetchLimit = 1
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects.first
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return nil
        }
    }
    
    /// Return array of Object by name master/instance
    func findObjects(name: String, isMasterObject: Bool) -> [Item] {
        
        let valueString = isMasterObject ? "master":""
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name == %@ AND valueType == %i AND valueObject == %@", name, Item.ValueType.object(nil).rawValue, valueString
        )
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return []
        }
    }
    
    func findBy(uuid: String) -> Item? {
        let fetchRequest = Item.fetchRequest()
        if let uuid = NSUUID(uuidString: uuid) {
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Item.uuid), uuid)
        }else{
            return nil
        }
        
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects.first
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return nil
        }
    }
    
    /// Finds all Object type Items master/instance
    func findObjects(isMasterObject: Bool) -> [Item] {
        let valueString = isMasterObject ? "master":""
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "valueType == %i AND valueObject == %@", Item.ValueType.object(nil).rawValue, valueString)
        
        do{
            let objects = try moc.fetch(fetchRequest)
            return objects
        }catch{
            print("📛 Error: \(error)  \(#function) in EvaluationCRUD")
            return []
        }
    }
    
    // MARK: - (U)pdate
    func update(item: Item){
        item.updatedAt = Date()
        save()
        print("⚠️ updated in ItemCRUD")
    }
    
    func delete(item: Item){
        item.itemsAsArray.forEach { item in
            delete(item: item)
        }
        moc.delete(item)
        save()
    }
}

// MARK: - Mock creation
extension ItemCRUD {
    static let rootItemName = "rootItem"
    
    func addInitialItem(){
        if findBy(name: ItemCRUD.rootItemName ).count < 1 {

            let newItem = getNewItem(name: ItemCRUD.rootItemName, parent: nil)
            newItem.name = ItemCRUD.rootItemName
            newItem.title = "Root Item"
            
            save()
        }
    }
    
    func addMockData(){
        if findAll().count < 5 {
            let itemNames = ["Item One", "Item Two", "Item Three", "Item Four", "Item Five"]
            
            let _ = itemNames.map{
                getNewItem(name: $0, parent: nil)
            }
            
            save()
        }
    }
}
