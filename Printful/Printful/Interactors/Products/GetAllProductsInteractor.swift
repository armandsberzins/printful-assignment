//
//  GetAllProductsInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import Combine
import Foundation

protocol GetAllProductsInteractor: Interactor, ProductsRepositoryProtocol {
    func getAllProducts(networkManager: NetworkManager) -> Future<[Product], ApiError>
}

extension GetAllProductsInteractor {
    func getAllProducts(networkManager: NetworkManager = NetworkManager()) -> Future<[Product], ApiError> {
        return getCachedOrFreshProducts(networkManager: networkManager)
    }
}
