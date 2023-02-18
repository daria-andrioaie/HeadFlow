//
//  Buttons.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.02.2023.
//

import Foundation
import SwiftUI

struct Buttons {
    enum Size {
        case small
        case medium
        case large
        
        var insets: EdgeInsets {
            var verticalInset: CGFloat
            var horizontalInset: CGFloat
            
            switch self {
            case .small:
                verticalInset = 12
                horizontalInset = 16
            case .medium:
                verticalInset = 16
                horizontalInset = 24
            case .large:
                verticalInset = 24
                horizontalInset = 32
            }
            
            return EdgeInsets(top: verticalInset, leading: horizontalInset, bottom: verticalInset, trailing: horizontalInset)
        }
    }
}


#if DEBUG
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                Buttons.BorderedButton(title: "Hello, world!", backgroundColor: .white, size: .large, width: 180, action: { })
                Buttons.FilledButton(title: "Hello, world!", size: .large, width: 180, action: { })
            }
            
            HStack(spacing: 10) {
                Buttons.BorderedButton(title: "Small", backgroundColor: .white, action: { })
                Buttons.FilledButton(title: "Small", action: { })
            }
            
            HStack(spacing: 10) {
                Buttons.BorderedButton(title: "Random", isEnabled: false, backgroundColor: .white, action: { })
                Buttons.FilledButton(title: "Random", isEnabled: false, backgroundColor: .apricot, foregroundColor: .danubeBlue,  action: { })
            }
        }
    }
}
#endif
