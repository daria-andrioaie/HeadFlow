//
//  MenuItemView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import SwiftUI

struct MenuItemView: View {
    
    let item: MenuItem
    let hasNotification: Bool
    let action: () -> Void
    
    init(item: MenuItem, hasNotification: Bool = false, action: @escaping () -> Void) {
        self.item = item
        self.hasNotification = hasNotification
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                item.image
                    .renderingMode(.template)
                    .foregroundColor(.danubeBlue)
                    .padding(.trailing, 10 )
                Text(item.title)
                    .foregroundColor(.oceanBlue)
                    .font(.Main.medium(size: 16))
                
                if hasNotification {
                    notificationBubbleView
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.danubeBlue)
            }
            .padding(.horizontal, 24)
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.diamond.opacity(0.6).cornerRadius(15))
        }
        .buttonStyle(.plain)
    }
    
    var notificationBubbleView: some View {
        Circle()
            .foregroundColor(.red.opacity(0.8))
            .frame(width: 8)
    }
}

#if DEBUG
struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            VStack {
                MenuItemView(item: .editProfile, hasNotification: true) {}
                MenuItemView(item: .therapistCollaboration) {}
            }
            .padding(.vertical)
            .background(Color.feathers)
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
#endif
