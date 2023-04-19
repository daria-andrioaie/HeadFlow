//
//  PillButton.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import SwiftUI

extension Buttons {
    struct PillButton: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Text(title)
                        .foregroundColor(isSelected ? .feathers : .danubeBlue)
                        .font(.Main.medium(size: 18))
                }
                .contentShape(Rectangle())
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isSelected ? Color.danubeBlue : Color.white)
                )
                .roundedBorder(Color.danubeBlue, cornerRadius: 25)
            }
            
            .buttonStyle(.plain)
        }
    }
}


struct PillButton_Previews: PreviewProvider {
    static var previews: some View {
        Buttons.PillButton(title: "Button", isSelected: false, action: { })
    }
}
