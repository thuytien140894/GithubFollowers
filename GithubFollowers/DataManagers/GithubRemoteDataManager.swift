//
//  GithubRemoteDataManager.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import Foundation

final class GithubRemoteDataManager {
    private let connector: Connector
    private let baseURL = "https://api.github.com/users/"
    
    init(connector: Connector = URLSession.shared) {
        self.connector = connector
    }
    
    func fetchFollowers(username: String, page: Int) async throws -> [Follower] {
        let urlString = "\(baseURL)\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: urlString) else {
            throw NetworkingError.malformedURL
        }
        
        let data = try await connector.fetch(from: url)
        let followers = try JSONDecoder().decode([Follower].self, from: data)
        
        return followers
    }
}

extension GithubRemoteDataManager: ImageDownloader {
    func downloadImage(from url: URL) async throws -> Data {
        let data = try await connector.fetch(from: url)
        return data
    }
}

extension GithubRemoteDataManager {
    enum NetworkingError: Error {
        case malformedURL
    }
}
