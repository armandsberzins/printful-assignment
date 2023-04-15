//
//  GetProductInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import Combine
import Foundation

protocol GetProductInteractor: Interactor, ProductsRepositoryProtocol {
    func getProduct(by productId: Int, networkManager: NetworkManager) -> Future<Product?, ApiError>
}

extension GetProductInteractor {
    func getProduct(by productId: Int, networkManager: NetworkManager = NetworkManager()) -> Future<Product?, ApiError> {
        return getCachedOrFreshProduct(by: productId, networkManager: networkManager)
    }
}
