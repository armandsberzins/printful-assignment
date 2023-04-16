//
//  CategoriesRepository.swift
//  Printful
//
//  Created by Armands Berzins on 07/04/2023.
//

import Combine
import Foundation

/**
 This repository retrurns categories.
 Be aware that data might be cached.
 */

typealias CategoriesByParent = [Int: [Category]]

class CategoriesRepository: Repository {
    
    private let url = Constants.URL.apiWith(path: "categories")
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func get(mandatoryDownload: Bool) -> Future<CateogryResult, ApiError> {
        Future { promise in
            
            CategoriesStorage.deleteOutdated()
            
            var localData: CateogryResult? = nil
            if !mandatoryDownload {
                localData = CategoriesStorage.load()
            }
            
            if let local = localData {
                promise(.success(local))
                self.updateInBackground()
            } else {
                let successHandler: (CateogryResponse) throws -> Void = { successResponse in
                    DispatchQueue.main.async {
                        CategoriesStorage.save(successResponse.result)
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

    func getCategoriesGroupedByParent(mandatoryDownload: Bool) -> Future<CategoriesByParent?, ApiError> {
        Future { promise in
            
            CategoriesStorage.deleteOutdated()
            
            var localData: CategoriesByParent? = nil
            if !mandatoryDownload {
                localData = CategoriesStorage.loadCategoriesGroupedByParentId()
            }
            
            if let local = localData {
                promise(.success(local))
                self.updateInBackground()
            } else {
                let successHandler: (CateogryResponse) throws -> Void = { successResponse in
                    DispatchQueue.main.async {
                        CategoriesStorage.save(successResponse.result)
                        let result = CategoriesStorage.loadCategoriesGroupedByParentId()
                        promise(.success(result))
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

    private func updateInBackground() {
        let successHandler: (CateogryResponse) throws -> Void = { successResponse in
            DispatchQueue.main.async {
                CategoriesStorage.save(successResponse.result)
            }
        }
        
        self.networkManager.get(urlString: url,
                                successHandler: successHandler,
                                errorHandler: { _ in })
    }
}
