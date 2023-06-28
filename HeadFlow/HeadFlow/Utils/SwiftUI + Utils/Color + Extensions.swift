//
//  Color + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let feathers = Color("Feathers")
    static let diamond = Color("Diamond")
    static let apricot = Color("Apricot")
    static let classicRose = Color("ClassicRose")
    static let danubeBlue = Color("DanubeBlue")
    static let decoGreen = Color("DecoGreen")
    static let paleYellow = Color("PaleYellow")
    static let skyBlue = Color("SkyBlue")
    static let oceanBlue = Color("OceanBlue")
    
    static var random: Self {
        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}
