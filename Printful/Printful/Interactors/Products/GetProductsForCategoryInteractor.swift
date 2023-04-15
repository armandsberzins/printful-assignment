//
//  GetProductsForCategoryInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import Combine
import Foundation

protocol GetProductsForCategoryInteractor: Interactor, ProductsRepositoryProtocol {
    func getProducts(for category: Int, networkManager: NetworkManager) -> Future<[Product]?, ApiError>
}

extension GetProductsForCategoryInteractor {
    func getProducts(for category: Int, networkManager: NetworkManager = NetworkManager()) -> Future<[Product]?, ApiError> {
        return getCachedOrFreshProducts(for: category, networkManager: networkManager)
    }
}
