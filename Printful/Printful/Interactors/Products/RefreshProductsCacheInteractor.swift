//
//  RefreshProductsCacheInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import Foundation

protocol RefreshProductsCacheInteractor: Interactor, ProductsRepositoryProtocol {
    func refreshProductsCache(networkManager: NetworkManager)
}

extension RefreshProductsCacheInteractor {
    func refreshProductsCache(networkManager: NetworkManager = NetworkManager()) {
        return refreshProducts(networkManager: networkManager)
    }
}
