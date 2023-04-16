//
//  ProductsRepository.swift
//  Printful
//
//  Created by Armands Berzins on 11/04/2023.
//

import Combine
import Foundation

/**
 This repository retrurns data of products.
 Be aware that data might be cached.
 */

class ProductsRepository {
    
    private let url = Constants.URL.apiWith(path: "products")
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func get() -> Future<[Product], ApiError> {
        Future { promise in

            if let local = ProductsStorage.loadAll() {
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
    
    func get(for category: Int, mandatoryDownload: Bool = false) -> Future<[Product]?, ApiError> {
        Future { promise in
            
            var localData: [Product]? = nil
            if !mandatoryDownload {
                localData = ProductsStorage.load(for: category)
            }
            
            if let local = localData {
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
    
    func getFavorites() -> [Product]? {
        return ProductsStorage.loadFavorites()
    }
    
    func setFavoriteStatus(product: Product, value: Bool) {
        ProductsStorage.updateFavorite(for: product, with: value)
    }
    
    func getProduct(by productId: Int) -> Future<Product?, ApiError> {
        Future { promise in
            
            if let local = ProductsStorage.loadProduct(by: productId) {
                promise(.success(local))
            } else {
                let successHandler: (ProductResponse) throws -> Void = { successResponse in
                    DispatchQueue.main.async {
                        ProductsStorage.save(successResponse.result)
                        let filtered = ProductsStorage.loadProduct(by: productId)
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
    
    func updateInBackground() {
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
