//
//  User.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 04.03.2023.
//

import Foundation

enum UserType: String {
    case patient
    case therapist
}

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let type: UserType
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "userType"
        case firstName, lastName, email, phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        let typeAsString = try container.decode(String.self, forKey: .type)
        type = UserType(rawValue: typeAsString) ?? .patient
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(type.rawValue, forKey: .type)


    }
}
