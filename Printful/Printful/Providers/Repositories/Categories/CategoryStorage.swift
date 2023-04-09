//
//  CategoryStorage.swift
//  Printful
//
//  Created by Armands Berzins on 07/04/2023.
//

import CoreData
import Foundation

enum CategoryEnityKey: String {
    case id
    case parentId
    case imageUrl
    case position
    case size
    case title
}

struct CategoriesStorage {
    static let kModelName = "Category"
    static let kEntityName = "CategoryCD"
    
    static let kNilHolderInt = -999
    static let kNilHolderString = "NULLNULL"
    
    #warning("Improve Category to Entity converting for nil values")
    
    //MARK: - create
    static func save(_ result: CateogryResult) {
        let coreDataManager = CoreDataManager(modelName: kModelName)

        guard let entity = NSEntityDescription.entity(forEntityName: kEntityName, in: coreDataManager.managedObjectContext) else { return }



        result.categories.forEach { category in
            let categoryCD = NSManagedObject(entity: entity, insertInto: coreDataManager.managedObjectContext)
            
            categoryCD.setValue(category.id, forKey: CategoryEnityKey.id.rawValue)
            
            if let parent = category.parentID {
                categoryCD.setValue(parent, forKey: CategoryEnityKey.parentId.rawValue)
            } else {
                categoryCD.setValue(kNilHolderInt, forKey: CategoryEnityKey.parentId.rawValue)
            }
            
            if let value = category.imageURL {
                categoryCD.setValue(value, forKey: CategoryEnityKey.imageUrl.rawValue)
            } else {
                categoryCD.setValue(kNilHolderString, forKey: CategoryEnityKey.imageUrl.rawValue)
            }
            
            if let value = category.catalogPosition {
                categoryCD.setValue(value, forKey: CategoryEnityKey.position.rawValue)
            } else {
                categoryCD.setValue(kNilHolderInt, forKey: CategoryEnityKey.position.rawValue)
            }
            
            if let value = category.title {
                categoryCD.setValue(value, forKey: CategoryEnityKey.title.rawValue)
            } else {
                categoryCD.setValue(kNilHolderString, forKey: CategoryEnityKey.title.rawValue)
            }
            
            do {
                try coreDataManager.managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: - read
    static func load() -> CateogryResult? {
        let coreDataManager = CoreDataManager(modelName: kModelName)

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)

        do {
            let allCategoriesCD = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            
            if allCategoriesCD.isEmpty { return nil }
            
            let categories: [Category] = allCategoriesCD.compactMap { cd in
                let id = cd.value(forKey: CategoryEnityKey.id.rawValue) as? Int ?? kNilHolderInt
                
                var parent: Int? = nil
                if let value = cd.value(forKey: CategoryEnityKey.parentId.rawValue) as? Int {
                    if value != kNilHolderInt {
                        parent = value
                    }
                }
                
                var image: String? = nil
                if let value = cd.value(forKey: CategoryEnityKey.imageUrl.rawValue) as? String {
                    if value != kNilHolderString {
                        image = value
                    }
                }
                
                var position: Int? = nil
                if let value = cd.value(forKey: CategoryEnityKey.position.rawValue) as? Int {
                    if value != kNilHolderInt {
                        position = value
                    }
                }
                
                var title: String? = nil
                if let value = cd.value(forKey: CategoryEnityKey.title.rawValue) as? String {
                    if value != kNilHolderString {
                        title = value
                    }
                }
                
                return Category(id: id,
                                parentID: parent,
                         imageURL: image,
                         catalogPosition: position,
                         size: nil,
                         title: title)
            }.filter{ $0.id != kNilHolderInt }

            if categories.isEmpty { return nil }
            
            return CateogryResult(categories: categories)
        } catch {
            print("Error: Cloudn't load from cahce")
            return nil
        }
    }
    
    //MARK: - update
    /* add this when real single data update will happen */
    
    //MARK: - delete
    static func delete() {
        let coreDataManager = CoreDataManager(modelName: kModelName)
        
        guard let entity = NSEntityDescription.entity(forEntityName: kEntityName, in: coreDataManager.managedObjectContext) else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)
        
        do {
            let allCategoriesCD = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            
            allCategoriesCD.forEach {
                coreDataManager.managedObjectContext.delete($0)
            }
        } catch {
            print("Error: Cloudn't delete")
        }
        
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            print("Error: Cloudn't delete")
        }
    }
    
}
