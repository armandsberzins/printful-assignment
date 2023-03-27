//
//  DataContoller.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Basic")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
