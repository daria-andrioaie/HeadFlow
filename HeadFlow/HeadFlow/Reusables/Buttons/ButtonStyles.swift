//
//  ButtonStyles.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

struct ButtonStyles {
    struct Bordered: ButtonStyle {
        var isEnabled: Bool = true
        var fillColor: Color  = .white
        var borderColor: Color = .danubeBlue
        var size: Buttons.Size = .medium
        var width: CGFloat = 100
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(size.insets)
                .frame(width: width)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(fillColor)
                )
                .roundedBorder(borderColor, cornerRadius: 15, lineWidth: 1)
                .opacity(configuration.isPressed ? 0.7 : (isEnabled ? 1 : 0.5))
        }
    }
    
    struct Filled: ButtonStyle {
        var isEnabled: Bool = true
        var fillColor: Color  = .danubeBlue
        var size: Buttons.Size = .medium
        var width: CGFloat = 100
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(size.insets)
                .frame(width: width)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(fillColor)
                )
                .opacity(configuration.isPressed ? 0.8 : (isEnabled ? 1 : 0.5))
        }
    }
}


