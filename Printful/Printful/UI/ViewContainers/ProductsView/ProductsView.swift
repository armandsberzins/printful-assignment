//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        VStack {
            if viewModel.gridContent.isEmpty {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    FlexibleView(
                        availableWidth: UIScreen.main.bounds.width, data: viewModel.gridContent,
                        spacing: 15,
                        alignment: .leading
                    ) { item in
                        Text(verbatim: item.title)
                            .font(.system(.body, weight: .semibold))
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.1))
                            )
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}
