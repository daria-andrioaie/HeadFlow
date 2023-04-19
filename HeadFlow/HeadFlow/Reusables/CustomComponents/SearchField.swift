//
//  SearchField.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import SwiftUI

struct SearchField: View {
    
    @Binding var text: String
    static var fieldHeight: CGFloat = 48
    var placeholder: String? = nil
    var backgroundColor: Color = .diamond
    var foregroundColor: Color = .oceanBlue
    var isClearButtonShown: Bool = false
    var onCommit: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
            TextField(placeholder ?? "", text: $text, onCommit: {
                onCommit?()
            })
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .accentColor(foregroundColor)
            .foregroundColor(foregroundColor)
            .lineLimit(1)
            .font(.Main.h2SemiBold)
            .frame(height: 48)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .introspectTextField { textField in
                DispatchQueue.main.asyncAfter(seconds: 0.5) {
                    textField.becomeFirstResponder()
                }
            }
            .submitLabel(.search)
            
            if isClearButtonShown && !text.isEmpty {
                clearButtonView
            }
        }
        .padding(.horizontal, 24)
        .background(backgroundColor.cornerRadius(15)
            .roundedBorder(foregroundColor, cornerRadius: 15, lineWidth: 0.5)
        )
        //        .animation(.linear(duration: 0.25))
    }
    
    
    var clearButtonView: some View {
        HStack {
            Spacer()
            Button {
                text = ""
            } label: {
                Image(systemName: "x.circle")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(foregroundColor)
                    .opacity(0.5)
            }
            .buttonStyle(.plain)
        }
    }
}

#if DEBUG
struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldPreview()
    }
    
    private struct SearchFieldPreview: View {
        @State var empty = ""
        
        var body: some View {
            VStack(spacing: 20) {
                SearchField(text: $empty, placeholder: "Incepe o cautare")
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
