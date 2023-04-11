//
//  Constants.swift
//  Printful
//
//  Created by Armands Berzins on 11/04/2023.
//

import Foundation

struct Constants {
    
    struct URL {
        static var apiHost = "https://api.printful.com/"
        
        static func apiWith(path: String) -> String {
            return apiHost + path
        }
    }
}
