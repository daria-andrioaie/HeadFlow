//
//  NavigationBar.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import SwiftUI

struct NavigationBar: View {
    let title: String?
    let leftButtonAction: () -> Void
    
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
        }
        .padding(.horizontal, 24)
        .frame(height: 80)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationBar(title: "Daria is amazing", leftButtonAction: { })
            Spacer()
        }
        
    }
}
