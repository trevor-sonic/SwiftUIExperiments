//
//  ItemCRUD.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//

import Foundation

class ItemCRUD: BaseCRUD {
    
    // MARK: - (C)reate
    func getNewItem(name: String? = nil) -> Item {
        let e = Item(context: moc)
        e.uuid = UUID()
        e.name = name ?? "An Item"
        e.createdAt = Date()
        e.position = 0
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
    // MARK: - (U)pdate
    func update(item: Item){
        item.updatedAt = Date()
        save()
        print("⚠️ updated in ItemCRUD")
    }
}

// MARK: - Mock creation
extension ItemCRUD {
    func addMockData(){
        if findAll().count < 5 {
            let itemNames = ["Item One", "Item Two", "Item Three", "Item Four", "Item Five"]
            
            let _ = itemNames.map{
                getNewItem(name: $0)
            }
            
            save()
        }
    }
}
