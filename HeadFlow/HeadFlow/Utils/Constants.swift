//
//  Constants.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 02.03.2023.
//

import Foundation

struct Constants {
    static let SERVER_URL: ServerPathType = .hosted
    static let GOOGLE_CLIENT_ID = "977530065489-o48r8m20nafe3gpjeddjsbe0opdd108c.apps.googleusercontent.com"
    static let GOOGLE_SERVER_CLIENT_ID = "977530065489-t00pt7f3c5m59sqgv0m2k4n3h3amtio9.apps.googleusercontent.com"
}

extension Constants {
    enum ServerPathType: String {
        case local = "http://daria.local:3030/api/v1"
        case hosted = "https://headflow.onrender.com/api/v1"
    }
}
