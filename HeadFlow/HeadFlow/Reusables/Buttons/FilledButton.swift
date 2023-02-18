//
//  FilledButton.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

extension Buttons {
    struct FilledButton: View {
        let title: String
        
        var isEnabled: Bool = true
        var backgroundColor: Color  = .danubeBlue
        var foregroundColor: Color = .feathers
        var size: Size = .small
        var width: CGFloat = 100
        var font: Font = .Main.bold(size: 18)
        
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Text(title)
                    .foregroundColor(foregroundColor)
                    .font(font)
            }
            .buttonStyle(ButtonStyles.Filled(isEnabled: isEnabled, fillColor: backgroundColor, size: size, width: width))
            .disabled(!isEnabled)
        }
    }
}
