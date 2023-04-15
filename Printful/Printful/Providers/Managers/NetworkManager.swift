//
//  NetworkManager.swift
//  Printful
//
//  Created by Armands Berzins on 28/03/2023.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
typealias ErrorHandler = (ApiError) -> Void

class NetworkManager {
    
    func prepareUrlWith(stringToConvert: String) -> URL? {
        return URL(string: stringToConvert)
    }
    
    func isNetworkAvaliable(reachabilityManager: ReachabilityManager) -> Bool {
        return reachabilityManager.isConnectedToNetwork()
    }
    
    func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
    
    func get<T: Decodable>(urlString: String,
                           headers: [String: String] = [:],
                           successHandler: @escaping (T) throws -> Void,
                           errorHandler: @escaping ErrorHandler) {
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                self.tryIdentifyError(data, errorHandler: errorHandler)
                print(error.localizedDescription)
                return
            }
            
           if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    print("Unable to parse the response in given type \(T.self)")
                    return errorHandler(.invalidData)
                }
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    do {
                        try successHandler(responseObject)
                    } catch {
                        self.tryIdentifyError(data, errorHandler: errorHandler)
                    }
                    return
                }
            }
            self.tryIdentifyError(data, errorHandler: errorHandler)
        }
        
        if isNetworkAvaliable(reachabilityManager: ReachabilityManager()) {
            if let validUrl = prepareUrlWith(stringToConvert: urlString) {
                var request = URLRequest(url: validUrl)
                request.allHTTPHeaderFields = headers
                URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
            } else {
                errorHandler(.wrongUrl)
            }
        } else {
            errorHandler(.noNetwork)
        }
    }
    
    private func tryIdentifyError(_ data: Data?, errorHandler: @escaping ErrorHandler) {
        guard let data = data else {
            return errorHandler(.invalidData)
        }
        if let responseObject = try? JSONDecoder().decode(PrintfulErrorResponse.self, from: data) {
            errorHandler(.printfulApi(errorText: responseObject.error.message))
            return
        }
        errorHandler(.serverError)
    }
}
