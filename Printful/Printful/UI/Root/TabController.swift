//
//  TabController.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import SwiftUI

class TabController: ObservableObject {
    @Published var activeTab = Tab.home
    
    func open(_ tab: Tab) {
        activeTab = tab
    }
}

enum Tab {
    case home
}
