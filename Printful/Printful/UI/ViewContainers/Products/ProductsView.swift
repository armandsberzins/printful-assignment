//
//  ProductDetailView.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var viewModel: ProductsViewModel
    
    let title: String
    
    init(categoryId: Int, title: String) {
        self.title = title
        _viewModel = StateObject(wrappedValue: ProductsViewModel(categoryId: categoryId))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    ProgressView()
                } else {
                    if (!viewModel.listContent.isEmpty) {
                        ProductList(products: viewModel.listContent,
                                    onFavoriteChanged: { viewModel.onFavoritePressed() }
                        )
                    }
                }
                
                if viewModel.error != nil {
                    Button("Try again load products", action: {
                        viewModel.onRetryError()
                    })
                }
            }.onAppear {
                viewModel.onAppear()
            }.refreshable {
                viewModel.onPullToRefresh()
            }
            .alert(
            isPresented: $viewModel.showAlert,
            content: { Alert(title: Text(viewModel.error?.description ?? "")) }
            )
        }.navigationBarTitle(title, displayMode: .large)
    }
}
