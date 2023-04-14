//
//  ProductsRepository.swift
//  Printful
//
//  Created by Armands Berzins on 11/04/2023.
//

import Combine
import Foundation

protocol ProductsRepositoryProtocol {
    func getCachedOrFreshProducts(networkManager: NetworkManager) -> Future<[Product], ApiError>
    func getCachedOrFreshProducts(for category: Int, networkManager: NetworkManager) -> Future<[Product]?, ApiError>
    func refreshProducts(networkManager: NetworkManager)
    func getCachedFavorites(networkManager: NetworkManager) -> [Product]?
    func setFavorite(for product: Product, networkManager: NetworkManager)
    func unsetFavorite(for product: Product, networkManager: NetworkManager)
}

extension ProductsRepositoryProtocol where Self: Interactor {
    func getCachedOrFreshProducts(networkManager: NetworkManager) -> Future<[Product], ApiError> {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        return productsRepo.get()
    }
    
    func getCachedOrFreshProducts(for category: Int, networkManager: NetworkManager) -> Future<[Product]?, ApiError> {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        return productsRepo.get(for: category)
    }
    
    func refreshProducts(networkManager: NetworkManager) {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        productsRepo.updateInBackground()
    }
    
    func getCachedFavorites(networkManager: NetworkManager) -> [Product]? {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        return productsRepo.getFavorites()
    }
    
    func setFavorite(for product: Product, networkManager: NetworkManager) {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        return productsRepo.setFavoriteStatus(product: product, value: true)
    }
    
    func unsetFavorite(for product: Product, networkManager: NetworkManager) {
        let productsRepo = ProductsRepository(networkManager: networkManager)
        return productsRepo.setFavoriteStatus(product: product, value: false)
    }
}

class ProductsRepository: Repository {
    
    private let url = Constants.URL.apiWith(path: "products")
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    fileprivate func get() -> Future<[Product], ApiError> {
        Future { promise in
            
            ProductsStorage.deleteOutdated()
            
            if let local = ProductsStorage.loadAll() {
                /** If data are stored already show them immediately and update in background
                 since these are not critcal time sensitive data
                 */
                
                promise(.success(local))
                self.updateInBackground()
            } else {
                let successHandler: (ProductResponse) throws -> Void = { successResponse in
                    DispatchQueue.main.async {
                        ProductsStorage.save(successResponse.result)
                    }
                    promise(.success(successResponse.result))
                }
                
                let errorHandler: (ApiError) -> Void = { networkManagerError in
                    print(networkManagerError.description)
                    promise(.failure(networkManagerError))
                }
                
                self.networkManager.get(urlString: self.url,
                                        successHandler: successHandler,
                                        errorHandler: errorHandler)
            }
        }
    }
    
    fileprivate func get(for category: Int) -> Future<[Product]?, ApiError> {
        Future { promise in
            
            ProductsStorage.deleteOutdated()
            
            if let local = ProductsStorage.load(for: category) {
                /** If data are stored already show them immediately and update in background
                 since these are not critcal time sensitive data
                 */
                
                promise(.success(local))
                self.updateInBackground()
            } else {
                let successHandler: (ProductResponse) throws -> Void = { successResponse in
                    DispatchQueue.main.async {
                        ProductsStorage.save(successResponse.result)
                        let filtered = ProductsStorage.load(for: category)
                        promise(.success(filtered))
                    }
                }
                
                let errorHandler: (ApiError) -> Void = { networkManagerError in
                    print(networkManagerError.description)
                    promise(.failure(networkManagerError))
                }
                
                self.networkManager.get(urlString: self.url,
                                        successHandler: successHandler,
                                        errorHandler: errorHandler)
            }
        }
    }
    
    fileprivate func getFavorites() -> [Product]? {
        return ProductsStorage.loadFavorites()
    }
    
    fileprivate func setFavoriteStatus(product: Product, value: Bool) {
        ProductsStorage.updateFavorite(for: product, with: value)
    }
    
    fileprivate func updateInBackground() {
        let successHandler: (ProductResponse) throws -> Void = { successResponse in
            DispatchQueue.main.async {
                ProductsStorage.save(successResponse.result)
            }
        }
        
        self.networkManager.get(urlString: url,
                                successHandler: successHandler,
                                errorHandler: { _ in })
    }
}
