//
//  ItemListBM.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 27/06/2023.
//

import Foundation


class ItemListBM {
    
    // MARK: - CoreData managed object
    private var moc = PersistenceController.shared.container.viewContext
  
    func fetchAllItems()->  [ItemBindableModel] {
        let allItems = ItemCRUD().findAll()
        let items = allItems.map { item in
            ItemBindableModel(item: item, moc: moc)
        }
        
        return items
    }
}
