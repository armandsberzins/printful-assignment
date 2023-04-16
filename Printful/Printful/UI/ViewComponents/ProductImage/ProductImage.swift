//
//  ProductImage.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import SwiftUI

struct ProductImage: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 1)
                        )
                    .padding(.horizontal, 8)
            } else if phase.error != nil {
                VStack {
                    Image(systemName: "xmark.square.fill")
                        .padding(.bottom, 1)
                    Text("No Image")
                }.font(.caption)
            } else {
                ProgressView()
            }
        }

    }
}
