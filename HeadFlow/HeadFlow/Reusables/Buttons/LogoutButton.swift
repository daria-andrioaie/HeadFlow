//
//  LogoutButton.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import SwiftUI

extension Buttons {
    struct LogoutButton: View {
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Image(.logoutIcon)
                        .renderingMode(.template)
                    Text(Texts.GeneralProfile.logoutButtonLabel)
                        .font(.Main.medium(size: 18))
                }
                .foregroundColor(.danubeBlue)
            }
            .buttonStyle(.plain)
        }
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        Buttons.LogoutButton { }
    }
}
