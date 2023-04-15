//
//  File.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Foundation

struct ProductRowModel: Hashable {

    let id = UUID()
    
    let title: String
    let isFavorite: Bool
    let favoriteAction: () -> Void
    let product: Product
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: ProductRowModel, rhs: ProductRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}
