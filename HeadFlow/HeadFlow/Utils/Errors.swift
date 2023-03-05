//
//  Errors.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

struct Errors {
    enum ValidationError: String, LocalizedError {
        case invalidPhoneNumber = "Invalid phone number"
        
        var errorDescription: String? {
            return self.rawValue
        }
    }
    
    struct APIError: Error, Decodable {
        let message: String
        var code: Int?
        
        static let defaultServerError: APIError = .init(message: "There was an unexpected error. Please try again later or contact support if the problem persists.")
    }

    struct CustomError: LocalizedError {
        var message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var errorDescription: String? { NSLocalizedString(message, comment: "") }
    }
}

