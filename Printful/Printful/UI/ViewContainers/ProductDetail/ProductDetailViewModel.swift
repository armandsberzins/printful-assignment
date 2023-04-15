//
//  ProductDetailViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import Combine
import Foundation

struct ProductDetailViewProperty {
    let title: String?
    let brand: String?
    let imageUrl: URL?
    let isFavorite: Bool
}

extension ProductDetailView {
    @MainActor
    class ProductDetailViewModel: ObservableObject, GetProductInteractor {
        
        let productId: Int
        
        @Published var product: ProductDetailViewProperty? = nil
        @Published var error: ApiError? = nil
        @Published var showAlert: Bool = false
        @Published var showLoading: Bool = false
        
        //MARK: - global objects
        private var cancelable: AnyCancellable?
        private static let productQueue = DispatchQueue(label: "productQueue")
        
        init(productId: Int) {
            self.productId = productId
            loadProduct(productId)
        }
        
        private func loadProduct(_ productId: Int) {
            error = nil
            showLoading = true
            cancelable = getProduct(by: productId)
                .subscribe(on: Self.productQueue)
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
        
        private func handle(_ product: Product?) {
            if let product = product {
                self.product = ProductDetailViewProperty(title: product.title,
                                                         brand: product.brand,
                                                         imageUrl: URL(string: product.image ?? ""),
                                                         isFavorite: product.isFavorite)
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
    
        //MARK: - deinit
        deinit {
            cancelable?.cancel()
        }
    }
}
