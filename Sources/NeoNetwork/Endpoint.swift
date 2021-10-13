//
//  Endpoint.swift
//  SpaceJam
//
//  Created by Ricardo Duarte on 10/10/2021.
//

import Foundation

public protocol NeoEndpoint {
    var httpScheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: HTTPMethod { get }
}

public extension NeoEndpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = httpScheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = filtered(queryItems)
        return urlComponents.url
    }
    
    func filtered(_ queryItems: [URLQueryItem]) -> [URLQueryItem]? {
        let filteredItems = queryItems.filter { $0.value != nil }
        return filteredItems.isEmpty ? nil : filteredItems
    }
}

