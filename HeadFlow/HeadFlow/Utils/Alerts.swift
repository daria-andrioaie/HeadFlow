//
//  Alerts.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.03.2023.
//

import Foundation
import SwiftUI

struct Alert {
    let title: String
    let message: String
}

extension Alert {
    static let airpodsAlert: Alert = .init(title: "Connect AirPods", message: "In order to complete the stretch, please connect your AirPods from the control panel or from settings.")
}
