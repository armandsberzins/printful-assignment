//
//  ApiError.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import Foundation

enum ApiError: Error {
    case noNetwork
    case invalidData
    case invalidBase
    case otherError
    case serverError
    case wrongUrl
}

extension ApiError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .noNetwork: return "You offline"
        case .invalidData: return "Invalid data: SOME_ERROR_CODE"
        case .invalidBase: return "Invalid base: SOME_ERROR_CODE"
        case .otherError: return "Something went wrong: SOME_ERROR_CODE"
        case .serverError: return "Server drunk: SOME_ERROR_CODE"
        case .wrongUrl: return "Wrong url: SOME_ERROR_CODE"
        }
    }
}
