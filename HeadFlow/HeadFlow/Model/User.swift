//
//  User.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 04.03.2023.
//

import Foundation

struct User: Decodable {
    let id: String
    let username: String
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
}
