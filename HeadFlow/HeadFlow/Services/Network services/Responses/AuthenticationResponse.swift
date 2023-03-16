//
//  AuthenticationResponse.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 14.03.2023.
//

import Foundation

struct AuthenticationResponse: Decodable {
    let user: User
    let token: String?
}
