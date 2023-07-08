//
//  CRUDBase.swift
//  Experimental (iOS)
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 23/06/2023.
//

import Foundation
import CoreData

class BaseCRUD {
    
    var moc: NSManagedObjectContext{ PersistenceController.shared.container.viewContext }
    
    func save(){
            do{
                try moc.save()
            }
            catch{
                print("📛 Error: \(error)  \(#function) in CRUDBase")
            }
        }
}
