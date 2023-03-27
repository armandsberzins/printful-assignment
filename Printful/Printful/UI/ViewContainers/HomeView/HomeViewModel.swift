//
//  HomeViewModel.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import Combine
import Foundation

extension HomeView {
    @MainActor
    class HomeViewModel: ObservableObject {
        //MARK: - dependencies
        
        //MARK: - outlets
        @Published var mainLableText = ""
        
        //MARK: - constants
        
        //MARK: - global objects
        
        //MARK: - setup
        init() {
            mainLableText = "Hello, Printful!"
        }
        
        //MARK: - lifecycle
        
        //MARK: - update data
        
        //MARK: - react on data change
        
        //MARK: - react on user action
        
        //MARK: - deinit
    }
}
