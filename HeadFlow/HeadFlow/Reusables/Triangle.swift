//
//  Triangle.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import SwiftUI

struct Triangle: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
        path.addCurve(to: CGPoint(x: rect.minX + radius, y: rect.maxY), control1: CGPoint(x: rect.minX, y: rect.maxY - 1/5 * radius), control2: CGPoint(x: rect.minX + 1/5 * radius, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - radius / 2, y: rect.midY + radius * 0.7))
        path.addCurve(to: CGPoint(x: rect.maxX - radius / 2, y: rect.midY - radius * 0.7), control1: CGPoint(x: rect.maxX, y: rect.midY + radius * 0.3), control2: CGPoint(x: rect.maxX, y: rect.midY - radius * 0.3))
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.minY + radius), control1: CGPoint(x: rect.minX + 1/5 * radius, y: rect.minY), control2: CGPoint(x: rect.minX, y: rect.minY + 1/5 * radius))
        
        return path
    }
}
