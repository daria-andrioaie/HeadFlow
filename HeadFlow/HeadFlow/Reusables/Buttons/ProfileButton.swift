//
//  ProfileButton.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import SwiftUI

extension Buttons {
    struct ProfileButton: View {
        let hasNotification: Bool
        let navigationAction: () -> Void
        
        var body: some View {
            Button {
                navigationAction()
            } label: {
                Image(.userProfileFilled)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.3), radius: 20, x: 5, y: 5)
                    .overlay(notificationOverlay, alignment: .topTrailing)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 40)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        @ViewBuilder
        var notificationOverlay: some View {
            if hasNotification {
                Circle()
                    .foregroundColor(.red.opacity(0.7))
                    .frame(width: 15)
            }
        }
    }
}

struct ProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        Buttons.ProfileButton(hasNotification: true, navigationAction: {})
    }
}
