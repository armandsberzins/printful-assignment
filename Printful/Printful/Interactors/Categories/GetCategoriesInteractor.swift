//
//  GetCategories.swift
//  Printful
//
//  Created by Armands Berzins on 09/04/2023.
//

import Combine
import Foundation

protocol GetCategoriesInteractor: Interactor, CategoriesRepositoryProtocol {
    func getCategories(networkManager: NetworkManager) -> Future<CateogryResult, ApiError>
}

extension GetCategoriesInteractor {
    func getCategories(networkManager: NetworkManager = NetworkManager()) -> Future<CateogryResult, ApiError> {
        return getCachedOrFreshCategories(networkManager: networkManager)
    }
}
