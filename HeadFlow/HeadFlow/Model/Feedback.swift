//
//  Feedback.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 01.06.2023.
//

import Foundation

extension Feedback {
    struct Model: Decodable {
        let sessionId: String
        let message: String
        let date: Int64
        let therapist: User
        
        enum CodingKeys: String, CodingKey {
            case sessionId = "session"
            case message, date, therapist
        }
        
        static let mock1: Feedback.Model = .init(sessionId: "1", message: "Very good", date: 1685617551953, therapist: .mockTherapist1)
    }
}
