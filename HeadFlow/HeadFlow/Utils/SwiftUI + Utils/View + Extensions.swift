//
//  View + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

extension View {
    func fillBackground(color: Color = .feathers, edges: Edge.Set = .vertical) -> some View {
        self
            .background(color.ignoresSafeArea(.container, edges: edges))
    }
    
    func roundedCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat = 5) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
    
    func roundedBorder(_ color: Color, cornerRadius: CGFloat, lineWidth: CGFloat = 1.5) -> some View {
        modifier(RoundedBorderModifier(color: color, cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    @ViewBuilder
    func activityIndicator(_ isLoading: Bool, scale: CGFloat = 1.3, tint: Color = .oceanBlue) -> some View {
        if isLoading {
            ActivityIndicator(tint: tint, scale: scale)
        } else {
            self
        }
    }
}


struct RoundedCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezierPath.cgPath)
    }
}
