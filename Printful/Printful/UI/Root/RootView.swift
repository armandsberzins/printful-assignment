//
//  RootView.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import SwiftUI

struct RootView: View {
    @StateObject private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.activeTab) {
            CategoriesView()
                .tag(Tab.home)
                .tabItem {
                    Label("Categories", systemImage: "tshirt.fill")
                }
            FavoritesView()
                .tag(Tab.favorites)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}
