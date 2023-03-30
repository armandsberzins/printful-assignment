//
//  BasicRepository.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import Combine
import Foundation

protocol BasicRepositoryProtocol {
    func get(inputParam: String) -> Future<Basic, ApiError>
}

class BasicRepository: BasicRepositoryProtocol {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    internal func get(inputParam: String) -> Future<Basic, ApiError> {
        Future { promise in
            
            if let localBasic = BasicStorage.loadBasic(for: "test") {
                promise(.success(localBasic))
                self.updateInBackground(inputParam: "test")
            } else {
                let successHandler: (Basic) throws -> Void = { basic in
                    BasicStorage.save(basic)
                    promise(.success(basic))
                }
                
                let errorHandler: (ApiError) -> Void = { networkManagerError in
                    print(networkManagerError.description)
                    promise(.failure(networkManagerError))
                }
                
                self.networkManager.get(urlString: "www.basic.com",
                                        successHandler: successHandler,
                                        errorHandler: errorHandler)
            }
        }
    }
    
    private func updateInBackground(inputParam: String) {
        self.networkManager.get(urlString: "www.basic.com",
                                successHandler: { basic in BasicStorage.save(basic)},
                                errorHandler: { _ in })
    }
}
