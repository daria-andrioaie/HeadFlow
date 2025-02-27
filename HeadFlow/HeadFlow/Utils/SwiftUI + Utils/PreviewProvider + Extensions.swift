//
//  PreviewProvider + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 26.03.2023.
//

import Foundation
import SwiftUI

extension PreviewDevice {
    static let iPhoneSE_3rd = PreviewDevice(rawValue: "iPhone SE (3rd generation)")
    static let iPhoneSE_1st = PreviewDevice(rawValue: "iPhone SE (1st generation)")
    static let iPhone11 = PreviewDevice(rawValue: "iPhone 11")
    static let iPhone13 = PreviewDevice(rawValue: "iPhone 13")
    static let iPhone14Pro = PreviewDevice(rawValue: "iPhone 14 Pro")
    static let iPhone13Max = PreviewDevice(rawValue: "iPhone 13 Pro Max")
    static let iPhone8Plus = PreviewDevice(rawValue: "iPhone 8 Plus")
    static let iPhone8 = PreviewDevice(rawValue: "iPhone 8")
    static let iPhone7Plus = PreviewDevice(rawValue: "iPhone 7 Plus")
}

extension PreviewDevice: Identifiable {
    public var id: String { self.rawValue }
}

extension PreviewProvider {
    static var previewDevices: [PreviewDevice] {
        [.iPhone8, .iPhone11, .iPhone14Pro]
    }
}
