//
//  ProductDetailView.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    
    init(productId: Int) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(productId: productId))
    }
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                        if let imageUrl = viewModel.product?.imageUrl {
                            ProductImage(url: imageUrl)
                        }
                    
                    if let title = viewModel.product?.title {
                        Text(verbatim: title)
                            .font(.system(.title, weight: .semibold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 8)
                            
                    }
                    if let brand = viewModel.product?.brand {
                        Text(verbatim: "by \(brand)")
                            .multilineTextAlignment(.leading)
                            .font(.system(.body, weight: .regular))
                            .foregroundColor(.accentColor)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)

                    }
                }
            }
        }
    }
}
