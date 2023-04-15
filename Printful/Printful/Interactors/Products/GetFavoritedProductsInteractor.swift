//
//  GetFavoritedProductsInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Combine
import Foundation

protocol GetFavoritedProductsInteractor: Interactor, ProductsRepositoryProtocol {
    func getFavoriteProducts(networkManager: NetworkManager) -> [Product]?
}

extension GetFavoritedProductsInteractor {
    func getFavoriteProducts(networkManager: NetworkManager = NetworkManager()) -> [Product]? {
        return getCachedFavorites(networkManager: networkManager)
    }
}

protocol RemoveFavoriteProductInteractor: Interactor, ProductsRepositoryProtocol {
    func removeFavoriteProduct(for product: Product, networkManager: NetworkManager)
}

extension RemoveFavoriteProductInteractor {
    func removeFavoriteProduct(for product: Product, networkManager: NetworkManager = NetworkManager()) {
        return unsetFavorite(for: product, networkManager: networkManager)
    }
}
