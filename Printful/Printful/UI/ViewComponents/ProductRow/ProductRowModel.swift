//
//  File.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Foundation

class ProductRowModel: Hashable {
    
    //MARK: - dependencies
    private let favoriteProductsInteractor: FavoriteProductsInteractor

    //MARK: - setup
    let rowId = UUID()
    let isFavorite: Bool
    var favoriteAction: (() -> Void)? = nil
    let product: Product
    var onFavoriteChanged: (() -> Void)? = nil
    
    init(product: Product, onFavoriteChanged: (() -> Void)?) {
        self.onFavoriteChanged = onFavoriteChanged
        self.product = product
        self.isFavorite = product.isFavorite
        self.favoriteProductsInteractor = FavoriteProductsInteractorImpementation()
        self.favoriteAction = { self.onFavoriteButtonPressed(product: product) }
    }
    
    //MARK: - confirm to protocols
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(rowId)
    }
    
    static func == (lhs: ProductRowModel, rhs: ProductRowModel) -> Bool {
        return lhs.rowId == rhs.rowId
    }
    
    //MARK: - react on user action
    func onFavoriteButtonPressed(product: Product) {
        if product.isFavorite {
            favoriteProductsInteractor.removeFavorite(for: product)
        } else {
            favoriteProductsInteractor.addFavorite(for: product)
        }
        
        if let onFavoriteChanged = onFavoriteChanged {
            onFavoriteChanged()
        }
    }
}
