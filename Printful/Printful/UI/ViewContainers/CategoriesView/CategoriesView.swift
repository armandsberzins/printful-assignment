//
//  ContentView.swift
//  Printful
//
//  Created by Armands Berzins on 27/03/2023.
//

import SwiftUI

#warning("Consider to make global error alert listener so .alert does not need to be implementet on every view (DRY)")

#warning("Improve code readability for this view")

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    ProgressView()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.sections) { section in
                                HStack {
                                    Text(section.title)
                                        .font(.system(.title2, weight: .semibold))
                                        .foregroundColor(.accentColor)
                                    //Spacer()
                                }.padding(.horizontal, 16)

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
                    }.padding(.horizontal, 0)
                }
                
                if viewModel.error != nil {
                    Button("Try again load categories", action: {
                        viewModel.loadCategories()
                    })
                }
                
            }.alert(
                isPresented: $viewModel.showAlert,
                content: { Alert(title: Text(viewModel.error?.description ?? "")) }
            ).navigationBarTitle("Categories", displayMode: .large)
        }
        
    }
}
