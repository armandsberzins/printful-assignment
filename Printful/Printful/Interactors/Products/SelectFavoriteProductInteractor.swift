//
//  SelectFavoriteProductInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import Foundation

protocol SelectFavoriteProductInteractor: Interactor, ProductsRepositoryProtocol {
    func selectFavoriteProduct(for product: Product, networkManager: NetworkManager)
}

extension SelectFavoriteProductInteractor {
    func selectFavoriteProduct(for product: Product, networkManager: NetworkManager = NetworkManager()) {
        return setFavorite(for: product, networkManager: networkManager)
    }
}
