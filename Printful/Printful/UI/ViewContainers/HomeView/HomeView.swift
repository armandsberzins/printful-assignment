//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @FetchRequest(sortDescriptors: []) var basics: FetchedResults<Basic>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            List(basics) { basic in
                Text(basic.title ?? "unknown")
                
            }
            
            Button("Add") {

                let object = Basic(context: moc)
                object.title = "Hello CD"
                try? moc.save()

                // more code to come
            }
        }
        .padding()
    }
}
