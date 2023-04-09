//
//  HomeViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import CoreData
import Combine
import Foundation

#warning("Add error handling and differentiate between no data because of loading and final no data")

extension ProductsView {
    @MainActor
    class ProductsViewModel: ObservableObject, GetCategoriesInteractor {
        //MARK: - dependencies
        
        //MARK: - outlets
        @Published var gridContent: [TagModel] = []
        @Published var error: ApiError? = nil
        @Published var showAlert: Bool = false
        
        //MARK: - constants
        
        //MARK: - global objects
        private var cancelable: AnyCancellable?
        private static let categoriesQueue = DispatchQueue(label: "CategoriesQueue")
        
        //MARK: - setup
        init() {
            loadCategories()
        }
        
        func loadCategories() {
            cancelable = getCategories()
                .subscribe(on: Self.categoriesQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.handle(completion)
                    },
                    receiveValue: {
                        self.handle($0.categories)
                    }
                )
        }
        
        //MARK: - lifecycle
        
        //MARK: - update data
        
        //MARK: - react on data change
        
        private func handle(_ categories: [Category]) {
            let gridFormat: [TagModel] = categories
                .filter{
                    $0.title != nil
                }
                .map {
                    let tagTitle = "\($0.title ?? "") P\(($0.parentID ?? 0) + 1)"
                    return TagModel(title: tagTitle)
                }
            
            self.gridContent = gridFormat
        }
        
        
        private func handle(_ completion: Subscribers.Completion<ApiError>) {
            switch completion {
            case .failure(let apiError):
                self.error = apiError
            case .finished:
                self.error = nil
            }

            self.showAlert = self.error != nil
        }
        
        //MARK: - react on user action
        
        //MARK: - deinit
        deinit {
            cancelable?.cancel()
        }
    }
}
