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
    case downloadedDate
}

struct CategoriesStorage {
    private static let kCacheTimeInMinutes = 10 // just my idea that 10 minutes is optimal cache time for categories
    
    private static let coreDataManager = CoreDataManager(modelName: "Category")
    private static let kEntityName = "CategoryCD"
    
    private static let kNilHolderInt = -999
    private static let kNilHolderString = "NULLNULL"

    //MARK: - create
    static func save(_ result: CateogryResult) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: kEntityName, in: coreDataManager.managedObjectContext) else { return }
        
        result.categories.forEach { category in
            let predicate = NSPredicate(format: "id = %ld", category.id)
            if load(with: predicate) != nil {
                delete(with: predicate)
            }
            
            let categoryCD = NSManagedObject(entity: entity, insertInto: coreDataManager.managedObjectContext)
            categoryCD.setValue(category.id, forKey: CategoryEnityKey.id.rawValue)
            categoryCD.setValue(Date.now, forKey: CategoryEnityKey.downloadedDate.rawValue)
            
            trySet(value: category.parentID, for: .parentId, in: categoryCD)
            trySet(value: category.imageURL, for: .imageUrl, in: categoryCD)
            trySet(value: category.catalogPosition, for: .position, in: categoryCD)
            trySet(value: category.title, for: .title, in: categoryCD)
            
            do {
                try coreDataManager.managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private static func trySet(value: String?, for key: CategoryEnityKey, in object: NSManagedObject) {
        if let value = value {
            object.setValue(value, forKey: key.rawValue)
        } else {
            object.setValue(kNilHolderString, forKey: key.rawValue)
        }
    }
    
    private static func trySet(value: Int?, for key: CategoryEnityKey, in object: NSManagedObject) {
        if let value = value {
            object.setValue(value, forKey: key.rawValue)
        } else {
            object.setValue(kNilHolderString, forKey: key.rawValue)
        }
    }
    
    //MARK: - read
    static func load() -> CateogryResult? {
        getFromDataBase()
    }
    
    static func load(with predicate: NSPredicate? = nil) -> Category? {
        let foundCategories = getFromDataBase(with: predicate)
        if let categories = foundCategories?.categories {
            if !categories.isEmpty {
                return categories.first
            }
        }
        return nil
    }
    
    static func loadCategoriesGroupedByParentId() -> CategoriesByParent? {
        let groupedCategories = getParentIds().reduce(into: CategoriesByParent()) {
            let predicate = NSPredicate(format: "parentId = %ld", $1)
            let categories: [Category] = getFromDataBase(with: predicate)?.categories ?? []
            return $0[$1] = categories
        }
        if groupedCategories.isEmpty { return nil }
        return groupedCategories
    }
    
    static func getParentIds() -> [Int] {
        let column = "parentId"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: kEntityName)
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.propertiesToFetch = [column]
        if let res = try? coreDataManager.managedObjectContext.fetch(request) as? [[String: Int]] {
            return res.compactMap { $0[column] }
        }
        return []
    }
    
    private static func getFromDataBase(with predicate: NSPredicate? = nil, sort: NSSortDescriptor? = nil) -> CateogryResult? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sort = sort {
            fetchRequest.sortDescriptors = [sort]
        }
        
        do {
            let allCategoriesCD = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            
            if allCategoriesCD.isEmpty { return nil }
            
            let categories: [Category] = allCategoriesCD.compactMap { cd in
                let id = cd.value(forKey: CategoryEnityKey.id.rawValue) as? Int ?? kNilHolderInt
                
                return Category(id: id,
                                parentID: tryReadInt(from: .parentId, in: cd),
                                imageURL: tryReadString(from: .imageUrl, in: cd),
                                catalogPosition: tryReadInt(from: .position, in: cd),
                                size: nil,
                                title: tryReadString(from: .title, in: cd))
            }.filter{ $0.id != kNilHolderInt }
            
            if categories.isEmpty { return nil }
            
            return CateogryResult(categories: categories)
        } catch {
            print("Error: Cloudn't load from cahce")
            return nil
        }
    }
    
    private static func tryReadInt(from key: CategoryEnityKey, in object: NSManagedObject) -> Int? {
        if let value = object.value(forKey: key.rawValue) as? Int {
            if value != kNilHolderInt {
                return value
            }
        }
        return nil
    }
    
    private static func tryReadString(from key: CategoryEnityKey, in object: NSManagedObject) -> String? {
        if let value = object.value(forKey: key.rawValue) as? String {
            if value != kNilHolderString {
                return value
            }
        }
        return nil
    }
    
    //MARK: - update
    /* add this when real single data update will happen */
    
    //MARK: - delete
    static func delete(with predicate: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            try coreDataManager.managedObjectContext.fetch(fetchRequest).forEach {
                coreDataManager.managedObjectContext.delete($0)
            }
        } catch {
            print("Error: Couldn't delete")
        }
        
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            print("Error: Couldn't delete")
        }
    }
    
    static func deleteOutdated() {

        let cal = Calendar.current

        guard let cacheExpDate = cal.date(byAdding: .minute, value: -1*kCacheTimeInMinutes, to: Date.now) else { return }
        
        let predicate = NSPredicate(format: "downloadedDate < %@", cacheExpDate as NSDate)
        
        delete(with: predicate)
    }
}
