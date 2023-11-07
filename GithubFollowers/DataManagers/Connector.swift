//
//  Connector.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import Foundation

enum ConnectorError: Error {
    case badResponse
}

protocol Connector {
    func fetch(from url: URL) async throws -> Data
}

extension URLSession: Connector {
    func fetch(from url: URL) async throws -> Data {
        guard let (data, response) = try await data(from: url) as? (Data, HTTPURLResponse),
              response.statusCode == 200 else {
            throw ConnectorError.badResponse
        }
        
        return data
    }
}
