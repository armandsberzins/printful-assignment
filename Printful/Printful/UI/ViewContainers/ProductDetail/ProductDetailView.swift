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


struct CacheAsyncImage<Content>: View where Content: View{
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View{
        if let cached = ImageCache[url]{
            let _ = print("cached: \(url.absoluteString)")
            content(.success(cached))
        }else{
            let _ = print("request: \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ){phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
        if case .success (let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
fileprivate class ImageCache{
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}
