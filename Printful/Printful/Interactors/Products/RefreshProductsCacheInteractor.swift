//
//  RefreshProductsCacheInteractor.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import Foundation

protocol RefreshProductsCacheInteractor {
    func updateCache()
}

class RefreshProductsCacheInteractorImpementation: RefreshProductsCacheInteractor {
    func updateCache() {
        return repository.updateInBackground()
    }
    
    private let repository: ProductsRepository
    
    init() {
        self.repository = ProductsRepository(networkManager: NetworkManager())
    }
}
