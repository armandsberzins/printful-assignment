//
//  Category.swift
//  Printful
//
//  Created by Armands Berzins on 07/04/2023.
//

import Foundation

// MARK: - Response
struct CateogryResponse: Codable {
    let code: Int
    let result: CateogryResult
}

// MARK: - Result
struct CateogryResult: Codable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let parentID: Int?
    let imageURL: String?
    let catalogPosition: Int?
    let size: Size?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case imageURL = "image_url"
        case catalogPosition = "catalog_position"
        case size, title
    }
}

enum Size: String, Codable {
    case small = "small"
    case medium = "medium"
    case large = "large"
}
