//
//  ProductStorage.swift
//  Printful
//
//  Created by Armands Berzins on 11/04/2023.
//

import CoreData
import Foundation

enum ProductEnityKey: String {
    case brand, id, image, mainCategoryID, title, downloadedDate, isFavorite
}

struct ProductsStorage {
    private static let kCacheTimeInMinutes = 10 // just my idea that 10 minutes is optimal cache time for categories
    
    private static let coreDataManager = CoreDataManager(modelName: "Product")
    private static let kEntityName = "ProductCD"
    
    private static let kNilHolderInt = -999
    private static let kNilHolderString = "NULLNULL"
    
#warning("Protocolize this Cache")
#warning("Limit who can use this Cache and what can use Cache")
    
    //MARK: - create
    static func save(_ results: [Product]) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: kEntityName, in: coreDataManager.managedObjectContext) else { return }
        
        results.forEach { product in
            var isFavorite = false
            
            let predicate = NSPredicate(format: "id = %ld", product.id)
            if let existingProduct = load(with: predicate)?.first {
                isFavorite = existingProduct.isFavorite
                delete(with: predicate)
            }
            
            let productCD = NSManagedObject(entity: entity, insertInto: coreDataManager.managedObjectContext)
            
            productCD.setValue(Date.now, forKey: ProductEnityKey.downloadedDate.rawValue)
            productCD.setValue(isFavorite, forKey: ProductEnityKey.isFavorite.rawValue)

            trySet(value: product.id, for: .id, in: productCD)
            trySet(value: product.mainCategoryID, for: .mainCategoryID, in: productCD)
            trySet(value: product.brand, for: .brand, in: productCD)
            trySet(value: product.image, for: .image, in: productCD)
            trySet(value: product.title, for: .title, in: productCD)
            
            do {
                try coreDataManager.managedObjectContext.save()
                //try coreDataManager.managedObjectContext.update()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private static func trySet(value: String?, for key: ProductEnityKey, in object: NSManagedObject) {
        if let value = value {
            object.setValue(value, forKey: key.rawValue)
        } else {
            object.setValue(kNilHolderString, forKey: key.rawValue)
        }
    }
    
    private static func trySet(value: Int?, for key: ProductEnityKey, in object: NSManagedObject) {
        if let value = value {
            object.setValue(value, forKey: key.rawValue)
        } else {
            object.setValue(kNilHolderInt, forKey: key.rawValue)
        }
    }
    
    //MARK: - read
    static func loadAll() -> [Product]? {
        getFromDataBase()
    }
    
    static func loadFavorites() -> [Product]? {
        let predicate = NSPredicate(format: "isFavorite = YES")
        return getFromDataBase(with: predicate)
    }
    
    static func load(for category: Int) -> [Product]? {
        let preicate = NSPredicate(format: "mainCategoryID = %ld", category)
        return getFromDataBase(with: preicate)
    }
    
    static func load(with predicate: NSPredicate) -> [Product]? {
        return getFromDataBase(with: predicate)
    }
    
    private static func tryReadString(from key: ProductEnityKey, in object: NSManagedObject) -> String? {
        if let value = object.value(forKey: key.rawValue) as? String {
            if value != kNilHolderString {
                return value
            }
        }
        return nil
    }
    
    private static func getFromDataBase(with predicate: NSPredicate? = nil) -> [Product]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let allProductsCD = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            
            if allProductsCD.isEmpty { return nil }
            
            let products: [Product] = allProductsCD.compactMap { productCD in
                let id = productCD.value(forKey: ProductEnityKey.id.rawValue) as? Int ?? kNilHolderInt
                let categoryId = productCD.value(forKey: ProductEnityKey.mainCategoryID.rawValue) as? Int ?? kNilHolderInt
                let favorite = productCD.value(forKey: ProductEnityKey.isFavorite.rawValue) as? Bool ?? false
                
                return Product(id: id,
                               mainCategoryID: categoryId,
                               type: nil,
                               description: nil,
                               typeName: nil,
                               title: tryReadString(from: .title, in: productCD),
                               brand: tryReadString(from: .brand, in: productCD),
                               model: nil,
                               image: tryReadString(from: .image, in: productCD),
                               variantCount: nil,
                               currency: nil,
                               options: nil,
                               dimensions: nil,
                               isDiscontinued: nil,
                               avgFulfillmentTime: nil,
                               techniques: nil,
                               files: nil,
                               originCountry: nil,
                               isFavorite: favorite)
                
            }.filter{ $0.id != kNilHolderInt && $0.mainCategoryID != kNilHolderInt }
            
            if products.isEmpty { return nil }
            
            return products
        } catch {
            print("Error: Cloudn't load from cahce")
            return nil
        }
    }
    
    //MARK: - update
    static func updateFavorite(for product: Product, with value: Bool) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %ld", product.id)
        do {
            let results = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            if results.count != 0 { // Atleast one was returned
                results[0].setValue(value, forKey: ProductEnityKey.isFavorite.rawValue)
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try coreDataManager.managedObjectContext.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
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
           // try coreDataManager.managedObjectContext.update()
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
