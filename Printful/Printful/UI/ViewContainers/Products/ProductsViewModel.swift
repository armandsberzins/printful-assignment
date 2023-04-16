//
//  ProductsViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 13/04/2023.
//

import CoreData
import Combine
import Foundation

@MainActor
class ProductsViewModel: ObservableObject {
    //MARK: - dependencies
    private let favoriteProductsInteractor: FavoriteProductsInteractor
    private let getProductsInteractor: GetProductsInteractor
    
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
        self.favoriteProductsInteractor = FavoriteProductsInteractorImpementation()
        self.getProductsInteractor = GetProductsInteractorImpementation()
        //loadProducts()
        //updateProductsCache()
    }
    
    func set(pageType: ProductsPageType) {
        switch pageType {
        case .category(let catId): categoryId = catId
        case.favorites: categoryId = 7
        }
        loadProducts()
        self.favoritedContent = favoriteProductsInteractor.getFavorites() ?? []
    }
    
    func loadProducts() {
        error = nil
        guard let catId = self.categoryId else {
            //show empty error
            return
        }
        showLoading = true
        cancelable = getProductsInteractor.getFor(category: catId)
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
        if product.isFavorite {
            favoriteProductsInteractor.removeFavorite(for: product)
        } else {
            favoriteProductsInteractor.addFavorite(for: product)
        }
        reload()
    }
    
    private func reload() {
        loadProducts()
        self.favoritedContent = favoriteProductsInteractor.getFavorites() ?? []
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
