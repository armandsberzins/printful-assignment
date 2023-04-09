//
//  HomeViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import CoreData
import Combine
import Foundation

extension HomeView {
    @MainActor
    class HomeViewModel: ObservableObject, GetCategoriesInteractor {
        //MARK: - dependencies
        
        //MARK: - outlets
        @Published var mainLableText = ""
        
        //MARK: - constants
        
        //MARK: - global objects
        private var cancelable: AnyCancellable?
        private static let categoriesQueue = DispatchQueue(label: "CategoriesQueue")
        
        //MARK: - setup
        
        init() {
            mainLableText = "Hello, Printful!"
            loadCategories()
        }
        
        private func loadCategories() {
            cancelable = getCategories()
                .subscribe(on: Self.categoriesQueue)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        self.handle(completion)
                    },
                    receiveValue: {
                        self.add($0.categories)
                    }
                )
        }
        
        //MARK: - lifecycle
        
        //MARK: - update data
        
        //MARK: - react on data change
        
        private func add(_ categories: [Category]) {
            print(categories)
//            let cellModel = ComicCellPorperties(title: comic.title,
//                                                issue: comic.num,
//                                                imageUrl: comic.img)
//
//            if self.comics == nil {
//                self.comics = ComicsViewProperies(arrayLiteral: cellModel)
//            } else {
//                self.comics?.append(cellModel)
//            }
        }
        
        
        private func handle(_ completion: Subscribers.Completion<ApiError>) {
//            switch completion {
//            case .failure(let apiError):
//                self.error = apiError
//            case .finished:
//                self.error = nil
//            }
//
//            self.showAlert = self.error != nil
        }
        
        //MARK: - react on user action
        
        //MARK: - deinit
        
    }
}
