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
            if let url = URL(string: model.imageUrl ?? "") {
                ProductImage(url: url).frame(width: 80, height: 80)
            }
            Text(verbatim: model.title)
                .font(.system(.body, weight: .semibold))
                .foregroundColor(.black)
                .padding(4)
            Spacer()
            if (model.isFavorite) {
                Image(systemName: "star.fill")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        model.favoriteAction()
                    }
                
            } else {
                Image(systemName: "star")
                    .foregroundColor(.black)
                    .onTapGesture {
                        model.favoriteAction()
                    }
            }
        }
    }
}


