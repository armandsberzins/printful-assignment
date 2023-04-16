//
//  ProductsViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 13/04/2023.
//

import CoreData
import Combine
import Foundation

extension ProductsView {
    @MainActor
    class ProductsViewModel: ObservableObject {
        //MARK: - dependencies
        private let favoriteProductsInteractor: FavoriteProductsInteractor
        private let getProductsInteractor: GetProductsInteractor
        
        //MARK: - outlets
        @Published var listContent: [Product] = []
        @Published var error: ApiError? = nil
        @Published var showAlert: Bool = false
        @Published var showLoading: Bool = false
        
        //MARK: - constants
        
        //MARK: - global objects
        private var cancelable: AnyCancellable?
        private static let productsQueue = DispatchQueue(label: "productsQueue")
        
        private var categoryId: Int
        
        //MARK: - setup
        init(categoryId: Int) {
            self.categoryId = categoryId
            self.favoriteProductsInteractor = FavoriteProductsInteractorImpementation()
            self.getProductsInteractor = GetProductsInteractorImpementation()
           // loadProducts(categoryId: categoryId)
            loadProducts(categoryId)
            //self.favoritedContent = favoriteProductsInteractor.getFavorites() ?? []
            //updateProductsCache()
        }
        
//        func set(pageType: ProductsPageType) {
//            switch pageType {
//            case .category(let catId): categoryId = catId
//            case.favorites: categoryId = 7
//            }
//            loadProducts()
//            self.favoritedContent = favoriteProductsInteractor.getFavorites() ?? []
//        }
        
        private func loadProducts(_ categoryId: Int) {
            error = nil

            showLoading = true
            cancelable = getProductsInteractor.getFor(category: categoryId)
                .subscribe(on: Self.productsQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.handle(completion)
                    },
                    receiveValue: {
                        self.handle($0)
                    }
                )
        }
        
        //MARK: - react on data change
        private func handle(_ products: [Product]?) {
            if let products = products {
                self.listContent = products
            } else {
                self.error = ApiError.noData
                showError()
            }
            
            showLoading = false
        }
        
        
        private func handle(_ completion: Subscribers.Completion<ApiError>) {
            switch completion {
            case .failure(let apiError):
                self.error = apiError
            case .finished:
                break
            }
            
            showLoading = false
            showError()
        }
        
        private func showError() {
            self.showAlert = self.error != nil
        }
        
        //MARK: - lifecycle
        func onAppear() {
            reload()
        }
        
        //MARK: - react on user action
        func reload() {
            loadProducts(self.categoryId)
        }
        
        //MARK: - deinit
        deinit {
            cancelable?.cancel()
        }
    }
}
