//
//  BasicStorage.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import CoreData
import Foundation

struct BasicStorage {
    static let cdName = "Basic"
    
    //MARK: - create
    static func save(_ basic: Basic) {
        let coreDataManager = CoreDataManager(modelName: cdName)
        
        guard let entity = NSEntityDescription.entity(forEntityName: cdName, in: coreDataManager.managedObjectContext) else { return }
        
        let basic = NSManagedObject(entity: entity, insertInto: coreDataManager.managedObjectContext)
        
        basic.setValue(basic, forKeyPath: "title")
        
        do {
          try coreDataManager.managedObjectContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - read
    static func loadBasic(for param: String) -> Basic? {
        let coreDataManager = CoreDataManager(modelName: cdName)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: cdName)

        fetchRequest.predicate = NSPredicate(format: "title LIKE %@", "\(param)")
        
        do {
            let basics = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            print(basics)
            
            if let title = basics.first?.value(forKey: "title") as? String {
                return Basic(title: title)
            }
            return nil
        } catch {
            print("Error: Cloudn't load from cahce")
            return nil
        }
    }
    
    //MARK: - update
    /* add this when real data will be known */
    
    //MARK: - delete
    /* add this when real data will be known */
}
