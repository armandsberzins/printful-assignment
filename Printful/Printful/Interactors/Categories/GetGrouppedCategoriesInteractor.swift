//
//  GetGrouppedCategories.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Combine
import Foundation

protocol GetGrouppedCategoriesInteractor: Interactor, CategoriesRepositoryProtocol {
    func getGrouppedCategories(forceFresh: Bool, networkManager: NetworkManager) -> Future<CategoriesByParent?, ApiError>
}

extension GetGrouppedCategoriesInteractor {
    func getGrouppedCategories(forceFresh: Bool, networkManager: NetworkManager = NetworkManager()) -> Future<CategoriesByParent?, ApiError> {
        if forceFresh {
            return getFreshCategoriesGroupedByParent(networkManager: networkManager)
        }
        return getCachedOrFreshCategoriesGroupedByParent(networkManager: networkManager)
    }
}
