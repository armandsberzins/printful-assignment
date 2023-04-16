//
//  GetFavoritedProductsInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Combine
import Foundation

protocol FavoriteProductsInteractor: Interactor {
    func getFavorites() -> [Product]?
    func removeFavorite(for product: Product)
    func addFavorite(for product: Product)
}

class FavoriteProductsInteractorImpementation: FavoriteProductsInteractor {
    func getFavorites() -> [Product]? {
        return repository.getFavorites()
    }
    
    func removeFavorite(for product: Product) {
        repository.setFavoriteStatus(product: product, value: false)
    }
    
    func addFavorite(for product: Product) {
        repository.setFavoriteStatus(product: product, value: true)
    }
    
    private let repository: ProductsRepository
    
    init() {
        self.repository = ProductsRepository(networkManager: NetworkManager())
    }
}
