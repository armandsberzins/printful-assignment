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
    func getFreshCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError>
    func getCachedOrFreshCategoriesGroupedByParent(networkManager: NetworkManager) -> Future<[Int: [Category]]?, ApiError>
}

extension CategoriesRepositoryProtocol where Self: Interactor {
    func getCachedOrFreshCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError> {
        let categoriesRepo = CategoriesRepository(networkManager: networkManager)
        return categoriesRepo.get(mandatoryDownload: false)
    }
    
    func getFreshCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError> {
        let categoriesRepo = CategoriesRepository(networkManager: networkManager)
        return categoriesRepo.get(mandatoryDownload: true)
    }
    
    func getCachedOrFreshCategoriesGroupedByParent(networkManager: NetworkManager) -> Future<[Int: [Category]]?, ApiError> {
        let categoriesRepo = CategoriesRepository(networkManager: networkManager)
        return categoriesRepo.getCategoriesGroupedByParent(mandatoryDownload: false)
    }
    
    func getFreshCategoriesGroupedByParent(networkManager: NetworkManager) -> Future<[Int: [Category]]?, ApiError> {
        let categoriesRepo = CategoriesRepository(networkManager: networkManager)
        return categoriesRepo.getCategoriesGroupedByParent(mandatoryDownload: true)
    }
}

class CategoriesRepository: Repository {
    
    private let url = Constants.URL.apiWith(path: "categories")
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    fileprivate func get(mandatoryDownload: Bool) -> Future<CateogryResult, ApiError> {
        Future { promise in
            
            CategoriesStorage.deleteOutdated()
            
            var localData: CateogryResult? = nil
            if !mandatoryDownload {
                localData = CategoriesStorage.load()
            }
            
            if let local = localData {
                /** If data are stored already show them immediately and update in background
                 since these are not critcal time sensitive data
                 */
                
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
    
    #warning("Typalias success response")
    
    fileprivate func getCategoriesGroupedByParent(mandatoryDownload: Bool) -> Future<[Int: [Category]]?, ApiError> {
        Future { promise in
            
            CategoriesStorage.deleteOutdated()
            
            var localData: [Int: [Category]]? = nil
            if !mandatoryDownload {
                localData = CategoriesStorage.loadCategoriesGroupedByParentId()
            }
            
            if let local = localData {
                /** If data are stored already show them immediately and update in background
                 since these are not critcal time sensitive data
                 */
                
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
