//
//  GetCategories.swift
//  Printful
//
//  Created by Armands Berzins on 09/04/2023.
//

import Combine
import Foundation

#warning("Limit who can use Interactor and what can use Interactor")
protocol GetCategoriesInteractor {
    func getCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError>
}

extension GetCategoriesInteractor {
    func getCategories(networkManager: NetworkManager = NetworkManager()) -> Future<CateogryResult, ApiError> {
        let categoriesRepo = CategoriesRepository()
        return categoriesRepo.get()
    }
}
