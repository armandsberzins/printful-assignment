//
//  ProductsViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 13/04/2023.
//

import CoreData
import Combine
import Foundation

#warning("Refactor interactors to classes to limit access to repositories")

@MainActor
class ProductsViewModel: ObservableObject,
                         GetProductsForCategoryInteractor,
                         SelectFavoriteProductInteractor,
                         RemoveFavoriteProductInteractor,
                         GetFavoritedProductsInteractor {
    //MARK: - dependencies
    
    //MARK: - outlets
    @Published var listContent: [Product] = []
    @Published var favoritedContent: [Product] = []
    @Published var error: ApiError? = nil
    @Published var showAlert: Bool = false
    @Published var showLoading: Bool = false
   // @Published var viewTitle = ""
    
    //MARK: - constants
    
    //MARK: - global objects
    private var cancelable: AnyCancellable?
    private static let productsQueue = DispatchQueue(label: "productsQueue")
    
    private var categoryId: Int?
    
    //MARK: - setup
    init() {
        //loadProducts()
        //updateProductsCache()
    }
    
    func set(pageType: ProductsPageType) {
        switch pageType {
        case .category(let catId): categoryId = catId
        case.favorites: categoryId = 7
        }
        loadProducts()
        favoritedContent = getFavoriteProducts() ?? []
    }
    
    func loadProducts() {
        error = nil
        guard let catId = self.categoryId else {
            //show empty error
            return
        }
        showLoading = true
        cancelable = getProducts(for: catId)
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
    
    //func get
    
//    private func setupTitle() {
//        viewTitle = "abc"
//    }
    
    //MARK: - lifecycle
    
    //MARK: - update data
    
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
    
    //MARK: - react on user action
    
    func onFavoriteButtonPressed(product: Product) {
        selectFavoriteProduct(for: product)
        self.favoritedContent = getFavoriteProducts() ?? []
    }
    
    //MARK: - deinit
    deinit {
        cancelable?.cancel()
    }
}

enum ProductsPageType {
    case category(Int)
    case favorites
}
