//
//  GetGrouppedCategories.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Combine
import Foundation

protocol GrouppedCategoriesInteractor {
    func get(forceFresh: Bool) -> Future<CategoriesByParent?, ApiError>
}

class GrouppedCategoriesInteractorImpementation: GrouppedCategoriesInteractor {
    func get(forceFresh: Bool) -> Future<CategoriesByParent?, ApiError> {
        return repository.getCategoriesGroupedByParent(mandatoryDownload: forceFresh)
    }
    
    private let repository: CategoriesRepository
    
    init() {
        self.repository = CategoriesRepository(networkManager: NetworkManager())
    }
}
