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
}

