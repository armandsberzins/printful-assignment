//
//  PrintfulApp.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

@main
struct PrintfulApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
