//
//  GetCategories.swift
//  Printful
//
//  Created by Armands Berzins on 09/04/2023.
//

import Combine
import Foundation

protocol GetCategoriesInteractor: Interactor, CategoriesRepositoryProtocol {
    func getCategories(forceFresh: Bool, networkManager: NetworkManager) -> Future<CateogryResult, ApiError>
}

extension GetCategoriesInteractor {
    func getCategories(forceFresh: Bool, networkManager: NetworkManager = NetworkManager()) -> Future<CateogryResult, ApiError> {
        if forceFresh {
            return getFreshCategories(networkManager: networkManager)
        }
        return getCachedOrFreshCategories(networkManager: networkManager)
    }
}
