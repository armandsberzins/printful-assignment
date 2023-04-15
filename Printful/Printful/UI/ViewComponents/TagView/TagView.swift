//
//  TagView.swift
//  Printful
//
//  Created by Armands Berzins on 12/04/2023.
//

import SwiftUI

struct TagView: View {
    let model: TagModel
    
    var body: some View {
        Text(verbatim: model.title)
            .font(.system(.body, weight: .semibold))
            .foregroundColor(.black)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.1))
            )
    }
}
