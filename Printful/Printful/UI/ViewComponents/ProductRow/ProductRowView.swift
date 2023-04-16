//
//  File.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import SwiftUI

struct ProductRowView: View {
    let model: ProductRowModel
    
    var body: some View {
        HStack {
            if let url = URL(string: model.product.image ?? "") {
                ProductImage(url: url).frame(width: 80, height: 80)
            }
            
            if let title = model.product.title {
                Text(verbatim: title)
                    .font(.system(.body, weight: .semibold))
                    .foregroundColor(.textColor)
                    .padding(4)
                Spacer()
            }

            if let favoritingAction = model.favoriteAction {
                if (model.product.isFavorite) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            favoritingAction()
                        }
                    
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.textColor)
                        .onTapGesture {
                            favoritingAction()
                        }
                }
            }
        }
    }
}


