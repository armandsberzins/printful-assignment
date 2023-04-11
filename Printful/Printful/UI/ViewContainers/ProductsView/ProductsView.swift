//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

#warning("Consider to make global error alert listener so .alert does not need to be implementet on every view (DRY)")

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
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
            
            if viewModel.error != nil {
                Button("Try again load categories", action: {
                    viewModel.loadCategories()
                })
            }
            
        }.alert(
            isPresented: $viewModel.showAlert,
            content: { Alert(title: Text(viewModel.error?.description ?? "")) }
        )
    }
}
