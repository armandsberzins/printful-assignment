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
            ProductsView()
                .tag(Tab.home)
                .tabItem {
                    Label("Products", systemImage: "tshirt.fill")
                }
        }
    }
}
