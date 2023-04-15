//
//  FavoritesView.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import SwiftUI

#warning("The same idea and functionalty as ProductsViewModel so have to handle reusability")
struct FavoritesView: View {
    @StateObject var viewModel = ProductsViewModel()
    
    let categoryId: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    ProgressView()
                } else {
                    if (!viewModel.favoritedContent.isEmpty) {
                        List {
                            ForEach(viewModel.favoritedContent) { item in
                                let model = ProductRowModel(title: item.title ?? "",
                                                            isFavorite: item.isFavorite, favoriteAction: { viewModel.onFavoriteButtonPressed(product: item) },
                                                            product: item)
                                ProductRowView(model: model)
                            }
                        }
                    }
                }
                
                if viewModel.error != nil {
                    Button("Try again load products", action: {
                        viewModel.loadProducts()
                    })
                }
            }.onAppear() {
                viewModel.set(pageType: .favorites)
            }.alert(
                isPresented: $viewModel.showAlert,
                content: { Alert(title: Text(viewModel.error?.description ?? "")) }
            ).navigationBarTitle("Favorites", displayMode: .large)
        }
    }
}
