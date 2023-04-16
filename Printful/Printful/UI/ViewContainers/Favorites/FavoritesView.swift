//
//  FavoritesView.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
     
    var body: some View {
        NavigationStack {
            VStack {
                if (!viewModel.productContent.isEmpty) {
                    ProductList(products: viewModel.productContent,
                                onFavoriteChanged: { viewModel.reload() }
                    )
                } else {
                    Text(verbatim: "😌  \n\nSeems like you don't have any favorite yet. \n\nJust browse our products catalog and press ⭐️ to add it to your list \n\n🐰")
                        .font(.system(.body, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(20)
                }
            }.onAppear {
                viewModel.onAppear()
            }.refreshable {
                viewModel.reload()
            }
            .navigationBarTitle("Favorites", displayMode: .large)
        }
    }
}
