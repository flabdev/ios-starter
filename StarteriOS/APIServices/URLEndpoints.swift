//
//  URLEndpoints.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 24/02/23.
//

import Foundation

//https://mocki.io/v1/e93144a0-0c50-4cb4-b13b-f031613fe61e

// This endpoint will be have path & queryItems for the urls which we use in this project.
struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

// MARK: Setting the Scheme & Host
extension Endpoint {
    // We are setting the scheme & host
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "mocki.io" // Sample Host
        components.path = "/" + path
        components.queryItems = queryItems

        // Check the Components are rightly generated
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

// MARK: Here we can define our endpoints
extension Endpoint {
    // Currently region is hardcoded
    static var getCards: Self {
        Endpoint(path: "v1/e93144a0-0c50-4cb4-b13b-f031613fe61e", queryItems: [])
    }
    
//    static func stockSummary(withSymbol symbol: String) -> Self {
//        Endpoint(path: "stock/v2/get-summary",queryItems: [URLQueryItem(name: "symbol", value: symbol),
//                                                            URLQueryItem(name: "region", value: "US")])
//    }
}
