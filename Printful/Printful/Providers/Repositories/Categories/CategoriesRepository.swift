//
//  CategoriesRepository.swift
//  Printful
//
//  Created by Armands Berzins on 07/04/2023.
//

import Combine
import Foundation

protocol CategoriesRepositoryProtocol {
    func getCachedOrFreshCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError>
}

extension CategoriesRepositoryProtocol where Self: Interactor {
    func getCachedOrFreshCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError> {
        let categoriesRepo = CategoriesRepository(networkManager: networkManager)
        return categoriesRepo.get()
    }
}

class CategoriesRepository: Repository {
    
    private let url = Constants.URL.apiWith(path: "categories")
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    fileprivate func get() -> Future<CateogryResult, ApiError> {
        Future { promise in
            
            CategoriesStorage.deleteOutdated()
            
            if let local = CategoriesStorage.load() {
                /** If data are stored already show them immediately and update in background
                 since these are not critcal time sensitive data
                 */
                
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
                
                self.networkManager.get(urlString: self.url,
                                        successHandler: successHandler,
                                        errorHandler: errorHandler)
            }
        }
    }
    
    private func updateInBackground() {
        self.networkManager.get(urlString: url,
                                successHandler: { successResponse in CategoriesStorage.save(successResponse)},
                                errorHandler: { _ in })
    }
}
