//
//  GetAllProductsInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import Combine
import Foundation

protocol GetProductsInteractor: Interactor {
    func getAll() -> Future<[Product], ApiError>
    func getFor(category: Int) -> Future<[Product]?, ApiError>
    func getBy(productId: Int) -> Future<Product?, ApiError>
}

class GetProductsInteractorImpementation: GetProductsInteractor {
    func getAll() -> Future<[Product], ApiError> {
        return repository.get()
    }
    
    func getFor(category: Int) -> Future<[Product]?, ApiError> {
        return repository.get(for: category)
    }
    
    func getBy(productId: Int) -> Future<Product?, ApiError> {
        return repository.getProduct(by: productId)
    }
    
    private let repository: ProductsRepository
    
    init() {
        self.repository = ProductsRepository(networkManager: NetworkManager())
    }
}
