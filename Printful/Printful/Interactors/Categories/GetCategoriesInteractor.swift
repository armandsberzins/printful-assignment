//
//  GetCategories.swift
//  Printful
//
//  Created by Armands Berzins on 09/04/2023.
//

import Combine
import Foundation

protocol GetCategoriesInteractor {
    func get(forceFresh: Bool) -> Future<CateogryResult, ApiError>
}

class GetCategoriesInteractorImpementation: GetCategoriesInteractor {
    func get(forceFresh: Bool) -> Future<CateogryResult, ApiError> {
        return repository.get(mandatoryDownload: forceFresh)
    }
    
    private let repository: CategoriesRepository
    
    init() {
        self.repository = CategoriesRepository(networkManager: NetworkManager())
    }
}
