//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    ProgressView()
                } else {
                    makeCategoriesGrid(viewModel.sections)
                }
                
                if viewModel.error != nil {
                    Button("Try again load categories", action: {
                        viewModel.onRefreshButtonPressed()
                    })
                }
                
            }.refreshable {
                viewModel.onRefreshButtonPressed()
            }
            .alert(
                isPresented: $viewModel.showAlert,
                content: { Alert(title: Text(viewModel.error?.description ?? "")) }
            ).navigationBarTitle("Categories", displayMode: .large)
        }
    }
    
    @ViewBuilder func makeCategoriesGrid(_ sections: [CategoriesSection]) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.sections) { section in
                    Text(section.title)
                        .font(.system(.title2, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 16)

                    FlexibleView(
                        availableWidth: UIScreen.main.bounds.width, data: section.tags,
                        spacing: 10,
                        alignment: .leading
                    ) { item in
                        NavigationLink(destination: ProductsView(categoryId: item.categoryId,
                                                                 title: item.title)) {
                            TagView(model: item)
                        }
                        
                    }.padding(.horizontal, 16)
                }
            }
        }
    }
}
