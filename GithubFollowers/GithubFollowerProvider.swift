//
//  GithubFollowerProvider.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import Foundation

final class GithubFollowerProvider: ObservableObject {
    @Published var followers: [Follower] = []
    let dataManager: GithubRemoteDataManager
    
    init(dataManager: GithubRemoteDataManager = .init()) {
        self.dataManager = dataManager
    }
    
    func loadFollowers(for username: String) {
        Task {
            do {
                followers = try await dataManager.fetchFollowers(username: username, page: 1)
            } catch {
                print(error)
            }
        }
    }
}
