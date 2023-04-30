//
//  NavigationBar.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct NavigationBar<RightView: View>: View {
    let title: String?
    let leftButtonAction: () -> Void
    
    @ViewBuilder var rightView: RightView
    
    var body: some View {
        HStack {
            Button {
                leftButtonAction()
            } label: {
                Circle()
                    .fill(Color.diamond)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .foregroundColor(.danubeBlue)
                    )
            }
            .buttonStyle(.plain)
            .padding(.trailing, 8)
            if let title {
                Text(title)
                    .font(.Main.semibold(size: 24))
                    .foregroundColor(.danubeBlue)
            }
            Spacer()
            rightView
        }
        .padding(.horizontal, 24)
        .frame(height: 80)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            NavigationBar(title: "Daria is amazing", leftButtonAction: { })
            NavigationBar(leftButtonAction: { })
            NavigationBar(title: "Hi", leftButtonAction: { }, rightView: {
                Image(systemName: "info.circle")
                    .foregroundColor(.danubeBlue)
            })
            Spacer()

        }
        
    }
}
