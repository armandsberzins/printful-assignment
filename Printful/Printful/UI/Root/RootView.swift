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
       // NavigationView {
            TabView(selection: $tabController.activeTab) {
                CategoriesView()
                    .tag(Tab.home)
                    .tabItem {
                        Label("Categories", systemImage: "tshirt.fill")
                    }
                FavoritesView(categoryId: 7)
                    .tag(Tab.favorites)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
      //  }.navigationViewStyle(StackNavigationViewStyle())
    }
}
