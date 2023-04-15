//
//  HomeViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import CoreData
import Combine
import Foundation

#warning("Refactor interactors to classes to limit access to repositories")

extension CategoriesView {
    @MainActor
    class CategoriesViewModel: ObservableObject,
                             GetCategoriesInteractor,
                               GetGrouppedCategoriesInteractor,
                               RefreshProductsCacheInteractor {
        
        //MARK: - dependencies
        
        //MARK: - outlets
        @Published var gridContent: [TagModel] = []
        @Published var sections: [CategoriesSection] = []
        @Published var error: ApiError? = nil
        @Published var showAlert: Bool = false
        @Published var showLoading: Bool = false
        
        //MARK: - constants
        
        //MARK: - global objects
        private var cancelable: AnyCancellable?
        private static let categoriesQueue = DispatchQueue(label: "CategoriesQueue")
        
        //MARK: - setup
        init() {
            loadGrouppedCategories(force: false)
            updateProductsCache()
            
            cancelable = getGrouppedCategories(forceFresh: false)
                .subscribe(on: Self.categoriesQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.handle(completion)
                    },
                    receiveValue: { categoriesByParentDic in
                        self.handle(categoriesByParentDic)
                    }
                )
        }
        
        private func loadGrouppedCategories(force: Bool) {
            showLoading = true
            
            cancelable = getGrouppedCategories(forceFresh: force)
                .subscribe(on: Self.categoriesQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.handle(completion)
                    },
                    receiveValue: { categoriesByParentDic in
                        self.handle(categoriesByParentDic)
                    }
                )
        }
        
        private func updateProductsCache() {
            refreshProductsCache()
        }
        
        //MARK: - lifecycle
        
        //MARK: - update data
        
        //MARK: - react on data change
        
        private func handle(_ categories: [Category]) {
            showLoading = false
            self.gridContent = convertToTagModel(categories: categories)
        }
        
        private func handle(_ grouppedCategories: [Int: [Category]]?) {
            grouppedCategories?
                .sorted { $0.key < $1.key }
                .forEach { parentId, categories in
                    let tags = convertToTagModel(categories: categories)
                    self.sections.append(CategoriesSection(parentId: parentId, tags: tags))
            }
            showLoading = false
        }
        
        private func handle(_ completion: Subscribers.Completion<ApiError>) {
            switch completion {
            case .failure(let apiError):
                self.error = apiError
            case .finished:
                self.error = nil
            }
            
            showLoading = false
            self.showAlert = self.error != nil
        }
        
        private func convertToTagModel(categories: [Category]) -> [TagModel] {
            return categories
                .filter {
                    $0.title != nil
                }
                .map {
                    return TagModel(title: $0.title ?? "", categoryId: $0.id)
                }
        }
        //MARK: - react on user action
        
        func onRefreshButtonPressed() {
            loadGrouppedCategories(force: true)
            updateProductsCache()
        }
        
        //MARK: - deinit
        deinit {
            cancelable?.cancel()
        }
    }
}

struct CategoriesSection: Identifiable {
    let id: Int
    let title: String
    let tags: [TagModel]
    
    init(parentId: Int, tags: [TagModel]) {
        self.id = parentId
        self.title = "Parent id - \(parentId)"
        self.tags = tags
    }
}
