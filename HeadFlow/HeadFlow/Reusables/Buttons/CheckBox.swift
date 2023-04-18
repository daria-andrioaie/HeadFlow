//
//  CheckBox.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import SwiftUI

extension Buttons {
    struct Checkbox: View {
        @Binding var isChecked: Bool
        
        var body: some View {
            Button {
                isChecked.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .roundedBorder(Color.oceanBlue, cornerRadius: 8, lineWidth: 1)
                    if isChecked {
                        Image(systemName: "checkmark")
                            .renderingMode(.template)
                            .foregroundColor(.danubeBlue)
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
                .animation(.linear(duration: 0.2), value: isChecked)
            }
            .buttonStyle(.plain)
        }
    }
}

#if DEBUG
struct CheckboxButton_Previews: PreviewProvider {
    static var previews: some View {
        Buttons.Checkbox(isChecked: .constant(true))
    }
}
#endif
