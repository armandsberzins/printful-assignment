//
//  File.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Foundation

struct ProductRowModel: Hashable {

    let rowId = UUID()
    let productId: Int
    let title: String
    let imageUrl: String?
    let isFavorite: Bool
    let favoriteAction: () -> Void
    let product: Product
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(rowId)
    }
    
    static func == (lhs: ProductRowModel, rhs: ProductRowModel) -> Bool {
        return lhs.rowId == rhs.rowId
    }
}
