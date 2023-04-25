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
            showLoading = true
            loadProducts(categoryId, force: false)
        }
        
        private func loadProducts(_ categoryId: Int, force: Bool = false) {
            error = nil
            cancelable = getProductsInteractor.getFor(category: categoryId, forceReload: force)
                .subscribe(on: Self.productsQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.handle(completion)
                    },
                    receiveValue: { [weak self] products in
                        self?.handle(products)
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
        
        private func reload(force: Bool) {
            loadProducts(self.categoryId)
        }
        
        //MARK: - lifecycle
        func onAppear() {
            reload(force: false)
        }
        
        //MARK: - react on user action
        func onPullToRefresh() {
            reload(force: true)
        }
        
        func onRetryError() {
            reload(force: true)
        }
        
        func onFavoritePressed() {
            reload(force: false)
        }
        
        //MARK: - deinit
        deinit {
            cancelable?.cancel()
        }
    }
}
