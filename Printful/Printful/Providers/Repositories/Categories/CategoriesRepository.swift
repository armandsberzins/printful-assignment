//
//  CategoriesRepository.swift
//  Printful
//
//  Created by Armands Berzins on 07/04/2023.
//

import Combine
import Foundation

protocol CategoriesRepositoryProtocol {
    func get() -> Future<CateogryResult, ApiError>
}

class CategoriesRepository: CategoriesRepositoryProtocol {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    internal func get() -> Future<CateogryResult, ApiError> {
        Future { promise in
            
            if let local = CategoriesStorage.load() {
                promise(.success(local))
                self.updateInBackground()
            } else {
                let successHandler: (CateogryResponse) throws -> Void = { successResponse in
                    CategoriesStorage.save(successResponse.result)
                    promise(.success(successResponse.result))
                }
                
                let errorHandler: (ApiError) -> Void = { networkManagerError in
                    print(networkManagerError.description)
                    promise(.failure(networkManagerError))
                }
                
                self.networkManager.get(urlString: "https://api.printful.com/categories",
                                        successHandler: successHandler,
                                        errorHandler: errorHandler)
            }
        }
    }
    
    private func updateInBackground() {
        self.networkManager.get(urlString: "https://api.printful.com/categories",
                                successHandler: { successResponse in CategoriesStorage.save(successResponse)},
                                errorHandler: { _ in })
    }
}
