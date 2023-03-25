//
//  StretchesResponse.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

struct StretchesResponse: Decodable {
    let success: Bool
    let stretches: [StretchSummary.Model]
}
