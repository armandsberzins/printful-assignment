//
//  ProductDetailView.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var viewModel = ProductsViewModel()
    
    let categoryId: Int
    let title: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    ProgressView()
                } else {
                    if (!viewModel.listContent.isEmpty) {
                        List {
                            ForEach(viewModel.listContent) { item in
                                NavigationLink(destination: ProductDetailView(productId: item.id)) {
                                    let model = ProductRowModel(productId: item.id, title: item.title ?? "", imageUrl: item.image,
                                                                isFavorite: item.isFavorite, favoriteAction: { viewModel.onFavoriteButtonPressed(product: item) },
                                                                product: item)
                                    ProductRowView(model: model)
                                }
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
                viewModel.set(pageType: .category(categoryId))
            }.alert(
                isPresented: $viewModel.showAlert,
                content: { Alert(title: Text(viewModel.error?.description ?? "")) }
            )
        }.navigationBarTitle(title, displayMode: .large)
    }
}
