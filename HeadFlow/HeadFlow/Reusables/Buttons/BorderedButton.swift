//
//  BorderedButton.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

extension Buttons {
    struct BorderedButton: View {
        let title: String
        
        var isEnabled: Bool = true
        var backgroundColor: Color  = .feathers
        var foregroundColor: Color = .danubeBlue
        var borderColor: Color = .danubeBlue
        var size: Size = .small
        var width: CGFloat = 100
        var font: Font = .Main.medium(size: 18)
        
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Text(title)
                    .foregroundColor(foregroundColor)
                    .font(font)
            }
            .buttonStyle(ButtonStyles.Bordered(isEnabled: isEnabled, fillColor: backgroundColor, borderColor: borderColor, size: size, width: width))
            .disabled(!isEnabled)
        }
    }
}
