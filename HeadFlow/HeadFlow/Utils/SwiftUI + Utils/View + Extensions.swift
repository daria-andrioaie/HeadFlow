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
    
    func toastDisplay(
        isPresented: Binding<Bool>,
        message: String,
        backgroundColor: Color = .decoGreen
    ) -> some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            self
            ToastDisplayView(
                isPresented: isPresented,
                message: message,
                backgroundColor: backgroundColor
            )
            .zIndex(1)
        }
    }
    
    func errorDisplay(
        error: Binding<Error?>,
        backgroundColor: Color = .red
    ) -> some View {
        var isPresentedBinding: Binding<Bool> {
            Binding {
                return error.wrappedValue != nil
            } set: { newValue in
                if !newValue {
                    error.wrappedValue = nil
                }
            }
        }
        
        return ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            self
            ToastDisplayView(
                isPresented: isPresentedBinding,
                message: error.wrappedValue?.localizedDescription ?? "",
                backgroundColor: backgroundColor
            )
            .zIndex(1)
        }
    }
    
    func customAlert(
        _ alert: Alert,
        isPresented: Binding<Bool>,
        @ViewBuilder iconView: () -> some View,
        @ViewBuilder cancelView: () -> some View,
        @ViewBuilder actionView: () -> some View
    ) -> some View {
        
        return ZStack(alignment: .center) {
            self
            CustomAlert(alert: alert, isPresented: isPresented, iconView: iconView, cancelView: cancelView, actionView: actionView)
        }
        .animation(.spring(), value: isPresented.wrappedValue)
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
