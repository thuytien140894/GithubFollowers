//
//  Follower.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import Foundation

struct Follower {
    let id: Int
    let login: String
    let avatarURL: URL
    
    var isFavorite = false
}

extension Follower: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Follower: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}

extension Follower: Hashable {
    
}
