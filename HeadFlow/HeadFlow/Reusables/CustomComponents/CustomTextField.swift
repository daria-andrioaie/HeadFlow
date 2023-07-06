//
//  CustomtextField.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation
import SwiftUI
import Introspect

struct CustomTextField: View {
    @Binding var inputText: String
    var placeholder: String?
    
    var foregroundColor: Color = .oceanBlue
    var backgroundColor: Color = .white
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var showKeyboardAutomatically: Bool = false
    var textInputAutoCapitalization: TextInputAutocapitalization = .never
    
    var inputError: Error? = nil
    var onCommit: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            if let inputError = inputError {
                Text(inputError.localizedDescription)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    .foregroundColor(.red)
                    .font(.Main.light(size: 12))
            }
            TextField(placeholder ?? "", text: $inputText, onCommit: {
                onCommit?()
            })
                .textInputAutocapitalization(textInputAutoCapitalization)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .accentColor(foregroundColor)
                .foregroundColor(foregroundColor)
                .lineLimit(1)
                .frame(height: 48)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .background(backgroundColor.cornerRadius(15)
                    .roundedBorder(inputError != nil ? Color.red : foregroundColor, cornerRadius: 15, lineWidth: 0.5)
                )
                .introspectTextField { textField in
                    if showKeyboardAutomatically {
                        DispatchQueue.main.asyncAfter(seconds: 0.5) {
                            textField.becomeFirstResponder()
                        }
                    }
                }
        }
        .animation(.easeInOut(duration: 0.25), value: inputError != nil)

    }
}
