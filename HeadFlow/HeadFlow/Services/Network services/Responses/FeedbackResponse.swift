//
//  FeedbackResponse.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 01.06.2023.
//

import Foundation

struct FeedbackResponse: Decodable {
    let success: Bool
    let feedback: Feedback.Model
}
