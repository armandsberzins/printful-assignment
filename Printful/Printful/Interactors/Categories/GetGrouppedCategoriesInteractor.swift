//
//  GetGrouppedCategories.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Combine
import Foundation

protocol GetGrouppedCategoriesInteractor: Interactor, CategoriesRepositoryProtocol {
    func getGrouppedCategories(networkManager: NetworkManager) -> Future<[Int: [Category]]?, ApiError>
}

extension GetGrouppedCategoriesInteractor {
    func getGrouppedCategories(networkManager: NetworkManager = NetworkManager()) -> Future<[Int: [Category]]?, ApiError> {
        return getCachedOrFreshCategoriesGroupedByParent(networkManager: networkManager)
    }
}
