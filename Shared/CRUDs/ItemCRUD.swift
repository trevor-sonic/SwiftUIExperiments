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
            //parent.items.insert(e)
            parent.addToItems(e)
        }
        
        return e
    }
    
    // MARK: - (R)ead
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
    func findObjects() -> [Item] {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "valueType == %i", Item.ValueType.object(nil).rawValue)
        
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
