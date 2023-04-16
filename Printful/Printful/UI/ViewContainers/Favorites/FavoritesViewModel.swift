//
//  FavoritesViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import Combine
import Foundation

extension FavoritesView {
    @MainActor
    class FavoritesViewModel: ObservableObject {
        //MARK: - dependencies
        private let favoriteProductsInteractor: FavoriteProductsInteractor
        private let refreshProductsInteractor: RefreshProductsCacheInteractor
        
        //MARK: - outlets
        @Published var productContent: [Product] = []
        
        //MARK: - setup
        init() {
            self.favoriteProductsInteractor = FavoriteProductsInteractorImpementation()
            self.refreshProductsInteractor = RefreshProductsCacheInteractorImpementation()
            self.productContent = favoriteProductsInteractor.getFavorites() ?? []
            self.refreshProductsInteractor.updateCache()
        }
        
        //MARK: - lifecycle
        func onAppear() {
            reload()
        }
        
        //MARK: - update data
        func reload() {
            self.productContent = favoriteProductsInteractor.getFavorites() ?? []
            self.refreshProductsInteractor.updateCache()
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
    }
}
