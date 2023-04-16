//
//  ProductImage.swift
//  Printful
//
//  Created by Armands Berzins on 16/04/2023.
//

import Foundation
import SwiftUI

struct ProductImage: View {
    let url: URL
    
    var body: some View {
        CacheAsyncImage(url: url) { phase in
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
                Text("Image unavaliable")
            } else {
                ProgressView()
            }
        }

    }
}
