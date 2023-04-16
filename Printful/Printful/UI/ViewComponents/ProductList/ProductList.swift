//
//  ProductList.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import SwiftUI

struct ProductList: View {
    let products: [Product]
    var onFavoriteChanged: (() -> Void)? = nil
    
    var body: some View {
        List {
            ForEach(products) { item in
                NavigationLink(destination: ProductDetailView(productId: item.id)) {
                    let model = ProductRowModel(product: item, onFavoriteChanged: onFavoriteChanged)
                    ProductRowView(model: model)
                }
            }
        }.animation(.default, value: products)
    }
}
