//
//  Image + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.02.2023.
//

import Foundation
import SwiftUI

enum HFImage: String {
    //MARK: images
    case mobility = "mobility-clipped"
    case posture = "posture-clipped"
    case sleep = "sleep-clipped"
}

extension Image {
    init(_ hfImage: HFImage) {
        self.init(hfImage.rawValue)
    }
}
