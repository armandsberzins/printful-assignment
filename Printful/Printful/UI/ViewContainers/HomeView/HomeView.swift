//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.mainLableText)
        }
        .padding()
    }
}
