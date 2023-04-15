//
//  PrintfulApiError.swift
//  Printful
//
//  Created by Armands Berzins on 14/04/2023.
//

import Foundation

struct PrintfulErrorResponse: Codable {
    let code: Int
    let reult: String?
    let error: PrintfulError
}

struct PrintfulError: Codable {
    let reason: Int?
    let message: String
}
